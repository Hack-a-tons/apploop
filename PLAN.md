# PLAN.md — AppLoop hackathon build plan

Feature-by-feature plan to ship a working, judge-ready AppLoop before the
**14 Oct 2026, 23:59 CEST** deadline.

Rulebook: `serverpod_hackathon.pdf` (judging: Does it work 30%, Serverpod
stack use 25%, craft/creativity 25%, usefulness 20%).

Prime directive: **a small loop that fully works beats a big loop that is
faked.** Every button in the MVP must do real work. App Store submission
and payments are roadmap, not stubs.

Build order follows dependencies (F0 → F9). F1 (app UI shell) and F2
(server models) can proceed in parallel once F0 lands. One person builds
strictly in order; with two, split app/server inside a feature.

## 0. Reference material (read before building)

- `~/bin/explain.sh` — `explain.sh debug screencast.mp4` turns a tester
  screencast with spoken comments into `issues.md` (transcript +
  per-issue screenshots + severity + tester quotes) and optionally maps
  issues to source files. F7 reuses this on the builder Mac.
- `~/Downloads/GitHub/brankovsky-git/PlantIdentify-iOS/fastlane/` — the
  proven TestFlight pipeline to copy the pattern from: `beta` lane (build
  number = latest on TestFlight + 1, `gym` build, upload internal),
  `distribute_external` (wait for processing → Beta Review → external
  group → notify), `expire_old_builds`, `retry_upload`. Auth is env-first
  (`ASC_PRIVATE_KEY` / `ASC_KEY_ID` / `ASC_ISSUER_ID`) with a local key-file
  fallback — AppLoop uses the same credentials and the same pattern.
- `~/Downloads/GitHub/Human-Rated-AI/fix` — intake → chunk → fix-loop
  concepts and the Mac-runner pattern (poll task → execute → post log).

## 1. Architecture

```text
apploop_flutter (Flutter, Material)          user's phone
  │  generated RPC + streams + file uploads
  ▼
apploop_server (Serverpod, Dart)             orchestrator, source of truth
  ├─ auth: serverpod_auth (email) — every row scoped to its owner
  ├─ db: PostgreSQL (embedded locally; real PG via Serverpod Cloud/prod)
  ├─ endpoints: Wish, StoreApp, Build, Feedback, Export
  ├─ files: Serverpod uploads, database storage (hackathon-simple)
  ├─ realtime: build status + log tail via Stream endpoints
  ├─ background: FutureCalls (provisioning, processing) — long blocking
  │   work (xcodebuild, fastlane) lives in the Mac worker, never in a call
  └─ web (Relic): landing page + GET /export/:wishId → Markdown download
apploop_client (generated — never edit by hand)
tool/mac_builder.dart (Dart worker)          runs on the owner's Mac:
  long-polls BuildEndpoint for queued build tasks, generates the Flutter
  app from the wish, builds, uploads to TestFlight with the same ASC
  credentials as PlantIdentify, posts status + log back to the server.
```

Why this scores "Serverpod stack use": Auth + relational ORM +
migrations + uploads + streams + FutureCalls + web routes + session
logs — real work on every layer.

## 2. Credentials & security (read carefully — public repo for judges)

All Apple credentials live **outside the repo**, exactly like PlantIdentify
does. Nothing below is a value — only names.

| Env var | Meaning |
| `ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_PRIVATE_KEY` | App Store Connect API key (same key as PlantIdentify; `.p8` content, never a file in the repo) |
| `ASC_KEY_FILE` | Builder-Mac fallback path to the `.p8` (same pattern as PlantIdentify's `~/Documents/...` fallback) |
| `APPLE_ID` / `APPLE_TEAM_ID` / `APPLE_TEAM_NAME` | Apple ID, team id, team name for signing |
| `APPLOOP_BUNDLE_PREFIX` | e.g. `com.hurated.loop` — per-wish apps become `<prefix>.<slug>` |
| `TESTFLIGHT_INTERNAL_GROUP` | Internal group name testers install from (default `AppLoop Internal`) |
| `VERTEX_AI_*` / `GOOGLE_APPLICATION_CREDENTIALS` | Only on the builder Mac, only if LLM issue extraction (F7) is enabled |

Rules:

- Server reads Apple credentials from `session.passwords` (i.e.
  `config/passwords.yaml`, already git-ignored) or process env — never
  from code, never from the client, never logged (redact in stored logs).
- Fastlane lanes take the same `ASC_*` env names as PlantIdentify so the
  owner's existing CI secrets work unchanged.
- The Flutter app never sees any Apple credential; it only sees
  TestFlight build numbers, states and install links.
- Pre-push sweep (F9): `git status` review + scan the staged diff for
  credential values (`.p8` blocks, key IDs, Apple ID, team ID).

## 3. Data model (Serverpod `.spy.yaml`, relations + migrations)

```yaml
# wish.spy.yaml (Serverpod v4: user rows attach via the auth module)
class: AppWish
table: app_wish
fields:
  authUser: module:serverpod_auth_core:AuthUser?, relation(onDelete=Cascade)
  title: String
  descriptionText: String, default=''
  status: String, default='draft'  # draft, provisioning, building, ...
  currentIteration: int, default=0
```

```yaml
# store_app.spy.yaml — one App Store Connect app per wish
class: StoreApp
table: store_app
fields:
  wishId: int, relation(parent=app_wish)
  bundleId: String          # <prefix>.<slug>, unique
  ascAppId: String, default=''   # App Store Connect app id once created
  sku: String
  appName: String
  status: String            # pending, creating, ready, failed
  statusLog: String, default=''
```

```yaml
# build.spy.yaml — one TestFlight build per iteration
class: AppBuild
table: app_build
fields:
  wishId: int, relation(parent=app_wish)
  storeAppId: int, relation(parent=store_app)
  iteration: int
  buildNumber: int, default=0      # TestFlight build number (latest+1)
  version: String, default='1.0'
  status: String  # queued, claimed, generating, building, uploading,
                  # processing, ready, failed
  statusLog: String, default=''
  testflightState: String, default=''  # Apple's externalBuildState mirror
```

```yaml
# recording.spy.yaml — tester's screen recording + audio comments
class: FeedbackRecording
table: feedback_recording
fields:
  buildId: int, relation(parent=app_build)
  authorId: int, relation(parent=serverpod_user_info)
  videoPath: String, default=''
  transcript: String, default=''
  issuesJson: String, default='[]'  # [{title, severity, timestamps, quote, fix}]
  status: String  # uploaded, processing, ready, failed
```

```yaml
# feedback.spy.yaml — one editable comment per extracted issue
class: FeedbackComment
table: feedback_comment
fields:
  recordingId: int, relation(parent=feedback_recording)
  authorId: int, relation(parent=serverpod_user_info)
  title: String
  text: String
  audioPath: String, default=''
  screenshotPath: String, default=''
  severity: String, default='medium'
  timestamps: String, default=''
  origin: String   # voice | keyboard | extracted
  resolved: bool, default=false
```

Migrations: `create_migration` + `apply_migrations` via the `serverpod`
MCP after every model change; `create_repair_migration` if the DB drifts.

## 4. Features

### F0 — Foundation

Goal: green baseline — auth, CI, docs, empty screens compiling.

- Server: enable `serverpod_auth` email in `lib/server.dart`; add the
  five models above (can land incrementally, wish first);
  `create_migration` + `apply_migrations`.
- App: sign-in screen wired to auth; bottom-nav shell (Wishes, Builds,
  Feedback, Export placeholders); `apploop_flutter/assets/config.json`
  keeps pointing at the local server.
- Repo: CI workflows already committed; README checkboxes tracked.
- Verify: `serverpod start` boots; sign up + sign in on a real phone;
  `dart analyze --fatal-infos`, `dart format`, `dart test` green.
- Done when: a signed-in user sees an empty wish list with their name.

### F1 — Voice wish intake

Goal: "talk to phone what app you want" creates a real Wish row.

- App: speak-wish sheet — mic button (`speech_to_text`, live transcript),
  title auto-taken from the first line, keyboard editing fallback, Save.
- Server: `WishEndpoint.createWish(title, description)`,
  `listMyWishes()`, `updateWish(id, ...)`, `deleteWish(id)`; all
  owner-scoped; session-logged.
- Verify: airplane-mode-safe error states; dictate a wish → row appears
  after app restart (proves persistence, not memory).
- Done when: two wishes created by voice survive restart and are
  owner-isolated (second test user sees none).

### F2 — App Store Connect provisioning (one app per wish)

Goal: a wish becomes a real app record in App Store Connect under the
same team/credentials as PlantIdentify.

- Server: `StoreAppEndpoint.requestApp(wishId)` — validates owner,
  derives `slug` from the title (lowercase, dashes, uniqueness counter),
  inserts `pending` StoreApp, schedules `provisionAppCall` FutureCall.
- FutureCall: with `ASC_*` from passwords/env, via ASC API (fastlane
  `produce` semantics): register bundle id `<prefix>.<slug>`, create app
  (name = wish title, SKU = slug, primary locale), store `ascAppId`,
  status `ready`; every step appended to `statusLog`.
- App: wish detail shows provisioning status + live log tail (Stream).
- Verify: request → App Store Connect web shows the new app; bundle id
  matches; re-request is idempotent (returns existing record).
- Done when: two wishes → two distinct apps visible in App Store Connect.
- Fallback (if the API key lacks Admin for app creation): pre-create the
  apps once from the owner's Mac and store their ids — the loop still
  works; document which path was taken.

### F3 — App generation from a wish

Goal: a wish deterministically generates a buildable Flutter app.

- Worker input: wish title + description + slug + bundle id.
- `tool/mac_builder.dart` step `generate`: `flutter create --org
  <prefix> --project-name <slug>` in a work dir, then overlay
  template files: app name, theme color (hash of slug), home screen
  showing wish title/description, and one functional module picked by
  keywords (counter / notes with local storage / checklist / quiz).
  Template-based v1 is declared openly in README — generation is real,
  deterministic and reviewable, not faked.
- Templates live in `tool/app_template/` in this repo (no secrets in
  them — only `YOUR_BUNDLE_ID` style placeholders filled at runtime).
- iOS signing: generated `ios/` keeps `CODE_SIGN_STYLE = Automatic`,
  team injected from `APPLE_TEAM_ID` env at build time only.
- Verify: generated project `flutter analyze` clean + `flutter build
  ios --simulator` green on the builder Mac for three sample wishes.
- Done when: generation is byte-deterministic for the same wish
  (diff of two runs is empty except timestamps).

### F4 — Mac builder worker (generate → build → upload)

Goal: unattended pipeline from queued build to TestFlight upload.

- Server: `BuildEndpoint.requestBuild(wishId)` (owner-checked, bumps
  iteration, inserts `queued` AppBuild); worker-facing
  `claimBuildTask()` (auth via builder token from passwords.yaml,
  atomic claim like the fix project's runner), `postBuildProgress(id,
  status, logAppend)`, `completeBuild(id, {buildNumber, state})`.
  Build number = latest on TestFlight + 1, computed server-side via ASC
  API before claiming (PlantIdentify `next_build_number` logic).
- Worker `tool/mac_builder.dart` (runs on the owner's Mac, long-polls):
  claim → generate (F3) → `fastlane beta`-equivalent lane in the
  generated project's `ios/fastlane/` (same env-first auth, same
  `gym` + `upload_to_testflight(internal)` flags as PlantIdentify) →
  upload → `processing` → complete. Full log streamed to server so the
  phone shows a live tail. Retry lane mirrors `retry_upload`
  (re-upload an existing `.ipa` without rebuilding).
- App: build detail screen — status chip + scrolling log + retry button
  on failure.
- Verify: request build → TestFlight internal build appears in App Store
  Connect; kill worker mid-build → task stays claimable (no stuck
  `claimed` older than 30 min without heartbeat).
- Done when: two consecutive iterations produce two sequential
  TestFlight builds with zero manual commands.

### F5 — TestFlight install & test

Goal: the user installs the real build on their phone from the AppLoop app.

- Server: `BuildEndpoint.testflightInfo(buildId)` returns build number,
  state, and the TestFlight redemption/install link (public TestFlight
  link of the internal group, configured once by the owner — no secret).
- App: "Install in TestFlight" button opens the link
  (`itms-beta://` / TestFlight public URL); build state chip mirrors
  Apple's processing → ready states (polled via worker/ASC, stored in
  `testflightState`).
- Practical rule: internal testers only for the loop (up to 100 Apple
  IDs, no Beta App Review wait). External distribution
  (`distribute_external` pattern) is a stretch feature, not MVP.
- Verify: on a real iPhone, tap → TestFlight opens → install → app
  launches and shows the wish content.
- Done when: the demo phone runs a build whose title came from a spoken
  wish ten minutes earlier.

### F6 — Test recordings upload

Goal: "install and test, record screen video with audio comments".

- App: test-session screen per build — "How to record" hint (iOS Control
  Center screen recording with microphone ON), then import the `.mov`
  from Photos/files (`file_picker`), optional trimming note, Upload
  with progress → `getVideoUploadDescription()` → verified
  `createRecording(buildId)`; audio-only fallback via `record`.
- Server: `FeedbackEndpoint` upload descriptions (video .mov/.mp4 ≤ 500
  MB, audio .m4a), owner-checked, stored under database storage;
  recording row `uploaded` → schedules processing (F7).
- Verify: 100 MB video uploads over LTE without timeout (chunked client
  retry); second user cannot fetch the file URL.
- Done when: a real on-device screen recording with voice is stored
  server-side and playable from the app.

### F7 — Feedback processing & review ("view & edit comments")

Goal: `explain.sh debug` as a service + editable comments.

- Worker step `process` (builder Mac, creds stay on the Mac): download
  recording → run `explain.sh debug video.mov -o work/` (ffmpeg +
  Vertex/Gemini creds from the Mac's own env, exactly as today) →
  parse `issues.md`/JSON (title, severity, timestamps, quote, fix) +
  per-issue screenshots → post back: `transcript`, `issuesJson`,
  screenshot files re-uploaded to the server; recording `ready`.
- Fallback (no Vertex creds on the builder): recording stays playable
  with an empty issue list and the user adds comments manually — the
  loop still works; the UI shows which path produced the issues.
- Server: `listComments(recordingId)`, `editComment(id, {title, text,
  severity})`, `setResolved(id, bool)`, `addManualComment(...)`
  (voice via STT or keyboard); every mutation owner-checked.
- App: comments screen — issue cards with severity chip, timestamp,
  tester quote, screenshot, audio playback when present; edit sheet
  (re-dictate or type); resolve toggle; progress "3/5 resolved".
- Verify: upload the PlantIdentify-style screencast → issues appear
  with timestamps matching the spoken words; edit one by voice; resolve
  two; counts update after restart.
- Done when: a recording's issues are reviewed, edited and resolved
  entirely on the phone.

### F8 — Loop iterations, satisfied, publish/export

Goal: "repeat until satisfied — publish / export (for $)".

- App: "New iteration" on a build with resolved-or-acknowledged
  comments → `requestBuild` (F4) → test → record → review. Iteration
  history per wish (v1 → v2 → …) with comment counts.
- `markSatisfied(wishId)` freezes the loop; Export button downloads
  `GET /export/<wishId>` Markdown: wish, all builds (numbers, states,
  TestFlight links), all recordings + comments + resolutions.
- Money: out of MVP scope — export page states the follow-up (paid
  publishing tiers à la fix/CONTRA model) as roadmap text. No dead
  payment buttons.
- Verify: full loop twice on one wish (v1 → 2 comments → v2 → satisfied
  → Markdown contains everything, incl. TestFlight links).
- Done when: the exported Markdown alone lets a stranger reproduce the
  whole story.

### F9 — Submission package

Goal: judges can install, run and verify everything.

- Video: < 2 min, real iPhone: speak wish → TestFlight install → test →
  voice comment → new build → export. Public YouTube/Vimeo link into
  README (replaces the TODO). No trademarks/music without permission.
- Text description on BuilderBase: features, functionality, how built,
  AI disclosure (OpenCode + Muse Spark; concepts adapted from the
  author's own `explain.sh` / `fix.hurated.com`; all code new).
- Run instructions: reviewer path (README) — `flutter pub get`,
  `serverpod start`; TestFlight testing needs an invited Apple ID
  (provide test credentials per rules §4 "Testing").
- Sweeps: secret scan of the pushed diff; `dart analyze
  --fatal-infos`, `dart format`, `dart test` green; cold-start check
  (fresh clone + fresh DB → full loop).
- Push to `https://github.com/Hack-a-tons/apploop` (public) and submit
  on BuilderBase before 14 Oct 2026, 23:59 CEST. Keep developing after
  the video if needed, but the video must show what judges get.

## 5. Testing strategy (per feature, not at the end)

- Server `dart test`: owner-isolation for every endpoint (second user
  gets nothing), provisioning idempotency, build-number sequencing,
  export content completeness. Run after each feature.
- Worker: `--dry-run` flag (generate only, no ASC calls) for fast
  iteration; heartbeat + stale-claim recovery covered by a test.
- App: widget tests for build-status chip, comment card, iteration
  list; device passes for F1 (mic), F5 (TestFlight install), F6
  (recording import).
- After every change (AGENTS.md): `dart analyze`, `dart format`,
  `hot_restart` for Flutter UI changes, `tail_server_logs` /
  `tail_flutter_logs` review.

## 6. Risks

| Risk | Mitigation |
| ASC API key lacks app-creation (Admin) rights | F2 fallback: pre-create apps on the Mac, store ids; loop unaffected |
| First Beta App Review is slow (external) | MVP uses internal testers only (instant); external = stretch |
| iOS builds take 10–20 min | Async by design: streams + log tail; user keeps using the app |
| Builder Mac sleeps/offline | Worker heartbeats; tasks re-queue after 30 min silence; document "builder must be awake" for the demo |
| Vertex creds missing on builder | F7 manual-comments fallback; loop still complete |
| 6 days total | Cut scope, never honesty: F2-fallback, F7-fallback, roadmap section exist so every shipped button is real |
| Secrets in a public repo | §2 rules + F9 sweep; credentials only via env/passwords.yaml |
