BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_build" (
    "id" bigserial PRIMARY KEY,
    "wishId" bigint NOT NULL,
    "storeAppId" bigint NOT NULL,
    "iteration" bigint NOT NULL,
    "buildNumber" bigint NOT NULL DEFAULT 0,
    "version" text NOT NULL DEFAULT '1.0'::text,
    "status" text NOT NULL DEFAULT 'queued'::text,
    "statusLog" text NOT NULL DEFAULT ''::text,
    "testflightState" text NOT NULL DEFAULT ''::text
);

-- Indexes
CREATE INDEX "app_build_wish_idx" ON "app_build" USING btree ("wishId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_wish" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "title" text NOT NULL,
    "descriptionText" text NOT NULL DEFAULT ''::text,
    "status" text NOT NULL DEFAULT 'draft'::text,
    "currentIteration" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE INDEX "app_wish_owner_idx" ON "app_wish" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "feedback_comment" (
    "id" bigserial PRIMARY KEY,
    "recordingId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "title" text NOT NULL,
    "text" text NOT NULL DEFAULT ''::text,
    "audioPath" text NOT NULL DEFAULT ''::text,
    "screenshotPath" text NOT NULL DEFAULT ''::text,
    "severity" text NOT NULL DEFAULT 'medium'::text,
    "timestamps" text NOT NULL DEFAULT ''::text,
    "origin" text NOT NULL DEFAULT 'keyboard'::text,
    "resolved" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "feedback_comment_recording_idx" ON "feedback_comment" USING btree ("recordingId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "feedback_recording" (
    "id" bigserial PRIMARY KEY,
    "buildId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "videoPath" text NOT NULL DEFAULT ''::text,
    "transcript" text NOT NULL DEFAULT ''::text,
    "issuesJson" text NOT NULL DEFAULT '[]'::text,
    "status" text NOT NULL DEFAULT 'uploaded'::text
);

-- Indexes
CREATE INDEX "feedback_recording_build_idx" ON "feedback_recording" USING btree ("buildId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "store_app" (
    "id" bigserial PRIMARY KEY,
    "wishId" bigint NOT NULL,
    "bundleId" text NOT NULL,
    "ascAppId" text NOT NULL DEFAULT ''::text,
    "sku" text NOT NULL,
    "appName" text NOT NULL,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "statusLog" text NOT NULL DEFAULT ''::text
);

-- Indexes
CREATE UNIQUE INDEX "store_app__bundleId__unique_idx" ON "store_app" USING btree ("bundleId");
CREATE INDEX "store_app_wish_idx" ON "store_app" USING btree ("wishId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_build"
    ADD CONSTRAINT "app_build_fk_0"
    FOREIGN KEY("wishId")
    REFERENCES "app_wish"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "app_build"
    ADD CONSTRAINT "app_build_fk_1"
    FOREIGN KEY("storeAppId")
    REFERENCES "store_app"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_wish"
    ADD CONSTRAINT "app_wish_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "feedback_comment"
    ADD CONSTRAINT "feedback_comment_fk_0"
    FOREIGN KEY("recordingId")
    REFERENCES "feedback_recording"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "feedback_comment"
    ADD CONSTRAINT "feedback_comment_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "feedback_recording"
    ADD CONSTRAINT "feedback_recording_fk_0"
    FOREIGN KEY("buildId")
    REFERENCES "app_build"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "feedback_recording"
    ADD CONSTRAINT "feedback_recording_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "store_app"
    ADD CONSTRAINT "store_app_fk_0"
    FOREIGN KEY("wishId")
    REFERENCES "app_wish"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR apploop
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('apploop', '20261008230750989', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261008230750989', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
