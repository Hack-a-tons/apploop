# AppLoop

> **Speak an app idea into your phone, get it on TestFlight, test it with
> voice comments, and loop until it's right — then export it.**

AppLoop is a full-stack Flutter + Serverpod entry for the **Build Something
Real: The Serverpod Hackathon** (submission period 15 Sep – 14 Oct 2026).

Repository: https://github.com/Hack-a-tons/apploop

## The loop

1. **Talk** — tell the phone what app you want (voice or keyboard). Your
   wish is saved to the Serverpod backend.
2. **Provision** — the server creates a real app for your wish in App
   Store Connect, under the same team and API credentials as the
   author's shipping app (see `~/Downloads/GitHub/brankovsky-git/
   PlantIdentify-iOS/fastlane/` for the proven pattern).
3. **Build** — a Mac builder worker generates the Flutter app from your
   wish, builds it and uploads to TestFlight. Status and log stream live
   to your phone.
4. **Test** — install the build from TestFlight and try it. While testing,
   record your screen with voice comments and upload the video.
5. **Review** — the recording is transcribed and split into issues
   (`explain.sh debug` pipeline); view every issue with its screenshot,
   play it back, edit the text (dictate again or type), resolve what's
   done.
6. **Repeat** — each round of feedback starts a new iteration with a fresh
   TestFlight build. Loop until you are satisfied.
7. **Export** — satisfied? Export the wish, all iterations and all feedback
   as a single Markdown package to take your app to production.

## Features (hackathon MVP)

- Email sign-in (Serverpod Auth) — wishes, apps, builds and feedback are
  strictly owner-scoped.
- Voice wishes via on-device speech-to-text, typed wishes as fallback.
- One App Store Connect app per wish (bundle id `<prefix>.<slug>`),
  created automatically; idempotent re-requests.
- Template-based app generation v1 (declared openly): deterministic,
  reviewable, buildable — keyword-matched module (counter / notes /
  checklist / quiz) dressed with your wish title and description.
- Unattended Mac builder: claim → generate → `gym` build → TestFlight
  upload (internal testers, no review wait) with live log tail and
  retry-without-rebuild.
- In-test feedback capture: screen recording + audio, uploaded with
  progress; server-side transcription into timestamped issues with
  screenshots (manual-comments fallback when no transcriber creds).
- Comment review: severity chips, tester quotes, screenshots, audio
  playback, voice-or-keyboard editing, resolve tracking per iteration.
- One-tap Markdown export of the whole loop (wish → apps → builds →
  recordings → comments).

Roadmap (not stubs, just not this week): external TestFlight
distribution with Beta Review, LLM-generated apps, App Store submission,
paid publishing tiers.

## How it was built

- **Backend:** Serverpod (Dart) — Auth, PostgreSQL ORM with relations and
  migrations, file uploads (video/audio/screenshots), streams for live
  build status and logs, FutureCalls for provisioning/processing,
  session logging, and a Relic web route serving the Markdown export.
- **App:** Flutter — Material UI, `speech_to_text`, `record`,
  `file_picker`, server-driven build/test flow, generated Serverpod
  client for all RPC.
- **Builder:** `tool/mac_builder.dart` (Dart) — long-polling worker on
  the owner's Mac; fastlane lanes mirror the author's PlantIdentify
  pipeline (env-first `ASC_*` auth, build number = TestFlight latest + 1,
  internal upload, old-build expiry).
- **Feedback engine:** the author's `~/bin/explain.sh debug` flow
  (screencast → transcript → issue list + screenshots, optionally mapped
  to sources), run on the builder Mac where its credentials live.
- **AI disclosure (hackathon rules, §4):** built with AI coding
  assistance (OpenCode, powered by Muse Spark). Design adapts the
  intake/chunk/fix-loop concepts of the author's earlier project
  `fix.hurated.com`; all AppLoop code was written fresh for this
  hackathon.
- Built live in Serverpod App Studio (`serverpod start`: incremental
  codegen + hot reload).

## How to build and run

Prerequisites: Flutter SDK (3.44+), the Serverpod CLI, and (for the
builder) Xcode 15+, fastlane, and the Apple credentials below. No Docker
needed — local runs and tests use Serverpod's embedded PostgreSQL.

```sh
# 1. Fetch dependencies (workspace root)
flutter pub get

# 2. Start backend + app with live reload (codegen, migrations and the
#    embedded database are handled automatically)
serverpod start
# — or, from inside apploop_server/:
cd apploop_server && serverpod start
```

The API runs on `http://localhost:8080`, the web server on
`http://localhost:8082`. The Flutter app spawns automatically (see
`serverpod: flutter_apps:` in `apploop_server/pubspec.yaml`).

> Email sign-in note: in local development the verification code is
> printed to the server console (look for `Registration code for ...`)
> instead of being emailed — that is Serverpod's default dev behavior,
> not a bug. Register with any email address and copy the code from the
> console. Staging and production send real emails through the
> Serverpod Cloud email service.

```sh
# 3. Start the Mac builder worker (separate terminal, on a Mac with
#    Xcode + fastlane + Apple credentials in the environment)
cd apploop_server && dart run tool/mac_builder.dart
```

The worker polls the server every 10 seconds, claims queued builds and
runs generate → fastlane beta → TestFlight upload → processing watch,
streaming the log back to the phone. It needs: `BUILDER_TOKEN` (same
value as the server `builderToken` password), `APPLOOP_SERVER_URL`
(default `http://localhost:8080/`), `APPLOOP_WORK_DIR` (default
`~/.apploop/builds`), `FLUTTER_BIN`/`FASTLANE_BIN` (defaults `flutter`/
`fastlane`), plus the Apple credentials below. `BUILD_NUMBER`,
`APP_IDENTIFIER` and the changelog are set per build automatically.

```sh
# Analyze, format, test (inside apploop_server/)
dart analyze
dart format .
dart test
```

### Apple credentials (never in the repo)

The server and builder read these from `config/passwords.yaml`
(git-ignored) or process environment — the same names the author's
PlantIdentify pipeline already uses:

`ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_PRIVATE_KEY` (App Store Connect
API key content), `ASC_KEY_FILE` (builder-Mac `.p8` fallback),
`APPLE_ID` / `APPLE_TEAM_ID` / `APPLE_TEAM_NAME` (signing),
`APPLOOP_BUNDLE_PREFIX` (e.g. `com.hurated.apploop`),
`TESTFLIGHT_INTERNAL_GROUP` (tester group). Transcriber credentials
(`VERTEX_AI_*`) live only on the builder Mac. The phone app never sees
any of these — only build numbers, states and install links.

## Project structure

```text
apploop_server/   Serverpod backend: models (*.spy.yaml), endpoints,
                  migrations, web routes, tests
  tool/           Mac builder worker + app templates (no secrets here)
apploop_client/   Generated RPC client (do not edit by hand)
apploop_flutter/  Flutter app: wishes, builds, testing, feedback, export
PLAN.md           Feature-by-feature build plan for the hackathon
```

## Demo video

< 2 min on a real iPhone: speak wish → TestFlight install → test with
voice comments → new build → export:
**TODO: add YouTube/Vimeo link before submission (deadline 14 Oct 2026,
23:59 CEST).**

## Submission checklist (rules §4)

- [x] Full-stack app with Serverpod as the backend, created new during
      the submission period.
- [x] Public code repository: https://github.com/Hack-a-tons/apploop
- [x] Text description (features, functionality, how built) — this file.
- [x] Build & run instructions — see above.
- [ ] Demonstration video (< 2 min, public YouTube/Vimeo link) — see above.
- [x] AI tooling disclosed — see "How it was built".
- [ ] TestFlight testing access for judges (invited Apple ID in the
      submission's testing instructions).

## License

MIT
