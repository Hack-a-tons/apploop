/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:apploop_client/src/protocol/builds/app_build.dart' as _i6akcqfa;
import 'package:apploop_client/src/protocol/builds/build_task.dart'
    as _i0ot5ooz;
import 'package:apploop_client/src/protocol/builds/testflight_info.dart'
    as _idjr27zf;
import 'package:apploop_client/src/protocol/feedback/feedback_recording.dart'
    as _iiwaw2h8;
import 'package:apploop_client/src/protocol/greetings/greeting.dart'
    as _i3hjhujy;
import 'package:apploop_client/src/protocol/store/store_app.dart' as _iv8bwsvn;
import 'package:apploop_client/src/protocol/wishes/wish.dart' as _isssl1tb;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Builds: one TestFlight build per loop iteration.
///
/// All methods require a signed-in user and only touch rows owned by
/// that user. The actual build work happens on the Mac builder worker
/// via [BuilderEndpoint]; this endpoint records intent and reports state.
/// {@category Endpoint}
class EndpointBuild extends _isc.EndpointRef {
  EndpointBuild(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'build';

  /// Requests a build for a wish owned by the caller. The wish must
  /// already have a provisioned (`ready`) store app, and Apple
  /// credentials must be configured. Assigns the next free TestFlight
  /// build number (latest on TestFlight and local rows + 1).
  _ida.Future<_i6akcqfa.AppBuild> requestBuild(int wishId) =>
      caller.callServerEndpoint<_i6akcqfa.AppBuild>(
        'build',
        'requestBuild',
        {'wishId': wishId},
      );

  /// Lists the caller's builds for one wish, newest first.
  _ida.Future<List<_i6akcqfa.AppBuild>> getBuildsForWish(int wishId) =>
      caller.callServerEndpoint<List<_i6akcqfa.AppBuild>>(
        'build',
        'getBuildsForWish',
        {'wishId': wishId},
      );

  /// Lists all of the caller's builds across wishes, newest first.
  _ida.Future<List<_i6akcqfa.AppBuild>> listMyBuilds() =>
      caller.callServerEndpoint<List<_i6akcqfa.AppBuild>>(
        'build',
        'listMyBuilds',
        {},
      );

  /// Loads one build owned by the caller.
  _ida.Future<_i6akcqfa.AppBuild> getBuild(int id) =>
      caller.callServerEndpoint<_i6akcqfa.AppBuild>(
        'build',
        'getBuild',
        {'id': id},
      );

  /// Everything the phone needs to install one owned build from
  /// TestFlight. The invite link is empty until the owner sets it on
  /// the store app.
  _ida.Future<_idjr27zf.TestflightInfo> testflightInfo(int id) =>
      caller.callServerEndpoint<_idjr27zf.TestflightInfo>(
        'build',
        'testflightInfo',
        {'id': id},
      );

  /// Re-queues a failed build owned by the caller.
  _ida.Future<_i6akcqfa.AppBuild> retryBuild(int id) =>
      caller.callServerEndpoint<_i6akcqfa.AppBuild>(
        'build',
        'retryBuild',
        {'id': id},
      );
}

/// Worker API for the Mac builder. No user login — every method takes
/// the shared builder token, which must match `builderToken` in
/// `config/passwords.yaml` (or the `SERVERPOD_PASSWORD_builderToken`
/// environment variable in CI). Fails closed when unconfigured.
/// {@category Endpoint}
class EndpointBuilder extends _isc.EndpointRef {
  EndpointBuilder(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'builder';

  /// Claims the next queued build (or a stale claim with no heartbeat
  /// for 30 minutes) and returns the work order, or null when idle.
  _ida.Future<_i0ot5ooz.BuildTask?> claimBuildTask(String builderToken) =>
      caller.callServerEndpoint<_i0ot5ooz.BuildTask?>(
        'builder',
        'claimBuildTask',
        {'builderToken': builderToken},
      );

  /// Appends to the build log, updates status and heartbeat.
  _ida.Future<void> postBuildProgress(
    String builderToken,
    int buildId,
    String status,
    String logAppend,
  ) => caller.callServerEndpoint<void>(
    'builder',
    'postBuildProgress',
    {
      'builderToken': builderToken,
      'buildId': buildId,
      'status': status,
      'logAppend': logAppend,
    },
  );

  /// Finishes a build as `ready` (on TestFlight) or `failed`.
  _ida.Future<void> completeBuild(
    String builderToken,
    int buildId,
    bool succeeded,
    String testflightState,
    String logAppend,
  ) => caller.callServerEndpoint<void>(
    'builder',
    'completeBuild',
    {
      'builderToken': builderToken,
      'buildId': buildId,
      'succeeded': succeeded,
      'testflightState': testflightState,
      'logAppend': logAppend,
    },
  );
}

/// Test recordings: screen videos with spoken comments, plus audio-only
/// notes. Flow: `startRecording` → upload video and/or audio with the
/// issued descriptions → `completeRecording` → (F7) processing.
///
/// Paths are always derived server-side (`feedback/<user>/<id>/…`);
/// clients never choose paths or storage ids.
/// {@category Endpoint}
class EndpointFeedback extends _isc.EndpointRef {
  EndpointFeedback(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'feedback';

  /// Starts a recording for a build owned by the caller.
  _ida.Future<_iiwaw2h8.FeedbackRecording> startRecording(int buildId) =>
      caller.callServerEndpoint<_iiwaw2h8.FeedbackRecording>(
        'feedback',
        'startRecording',
        {'buildId': buildId},
      );

  /// Upload description for the screen video (.mov/.mp4, ≤ 500 MB).
  _ida.Future<String> getVideoUploadDescription(int recordingId) =>
      caller.callServerEndpoint<String>(
        'feedback',
        'getVideoUploadDescription',
        {'recordingId': recordingId},
      );

  /// Upload description for the audio note (.m4a, ≤ 25 MB).
  _ida.Future<String> getAudioUploadDescription(int recordingId) =>
      caller.callServerEndpoint<String>(
        'feedback',
        'getAudioUploadDescription',
        {'recordingId': recordingId},
      );

  /// Marks the upload done after verifying at least one file landed.
  /// Throws when nothing was uploaded (client should retry the upload).
  _ida.Future<_iiwaw2h8.FeedbackRecording> completeRecording(int recordingId) =>
      caller.callServerEndpoint<_iiwaw2h8.FeedbackRecording>(
        'feedback',
        'completeRecording',
        {'recordingId': recordingId},
      );

  /// Time-limited playback URL for the video or audio (`kind` is
  /// `video` or `audio`).
  _ida.Future<String> downloadUrl(
    int recordingId,
    String kind,
  ) => caller.callServerEndpoint<String>(
    'feedback',
    'downloadUrl',
    {
      'recordingId': recordingId,
      'kind': kind,
    },
  );

  /// Lists the caller's recordings for one owned build, newest first.
  _ida.Future<List<_iiwaw2h8.FeedbackRecording>> listRecordings(int buildId) =>
      caller.callServerEndpoint<List<_iiwaw2h8.FeedbackRecording>>(
        'feedback',
        'listRecordings',
        {'buildId': buildId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i3hjhujy.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i3hjhujy.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Store apps: one App Store Connect app record per wish.
///
/// Provisioning itself runs in [ProvisionAppFutureCall]; this endpoint only
/// records the intent (idempotently) and schedules the work.
/// {@category Endpoint}
class EndpointStoreApp extends _isc.EndpointRef {
  EndpointStoreApp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'storeApp';

  /// Requests (or reuses) the store app for a wish owned by the caller.
  /// A failed provisioning is reset to pending and rescheduled.
  _ida.Future<_iv8bwsvn.StoreApp> requestApp(int wishId) =>
      caller.callServerEndpoint<_iv8bwsvn.StoreApp>(
        'storeApp',
        'requestApp',
        {'wishId': wishId},
      );

  /// Returns the store app for a wish owned by the caller, if any.
  _ida.Future<_iv8bwsvn.StoreApp?> getStoreAppForWish(int wishId) =>
      caller.callServerEndpoint<_iv8bwsvn.StoreApp?>(
        'storeApp',
        'getStoreAppForWish',
        {'wishId': wishId},
      );

  /// Sets the public TestFlight invite link for a store app owned by the
  /// caller (copied from App Store Connect; one link per app). Pass an
  /// empty link to clear it.
  _ida.Future<_iv8bwsvn.StoreApp> setTestflightLink(
    int storeAppId,
    String link,
  ) => caller.callServerEndpoint<_iv8bwsvn.StoreApp>(
    'storeApp',
    'setTestflightLink',
    {
      'storeAppId': storeAppId,
      'link': link,
    },
  );
}

/// Wishes: what the user told the phone they want built.
///
/// Every method requires a signed-in user and only ever touches rows
/// owned by that user (matched via the auth user id).
/// {@category Endpoint}
class EndpointWish extends _isc.EndpointRef {
  EndpointWish(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wish';

  /// Creates a wish from a spoken or typed title and description.
  _ida.Future<_isssl1tb.AppWish> createWish(
    String title,
    String description,
  ) => caller.callServerEndpoint<_isssl1tb.AppWish>(
    'wish',
    'createWish',
    {
      'title': title,
      'description': description,
    },
  );

  /// Lists the signed-in user's wishes, newest first.
  _ida.Future<List<_isssl1tb.AppWish>> listMyWishes() =>
      caller.callServerEndpoint<List<_isssl1tb.AppWish>>(
        'wish',
        'listMyWishes',
        {},
      );

  /// Replaces title and description of a wish owned by the caller.
  _ida.Future<_isssl1tb.AppWish> updateWish(
    int id,
    String title,
    String description,
  ) => caller.callServerEndpoint<_isssl1tb.AppWish>(
    'wish',
    'updateWish',
    {
      'id': id,
      'title': title,
      'description': description,
    },
  );

  /// Deletes a wish owned by the caller (builds and feedback cascade).
  _ida.Future<void> deleteWish(int id) => caller.callServerEndpoint<void>(
    'wish',
    'deleteWish',
    {'id': id},
  );

  /// Freezes the loop: the wish is done, ready for export.
  _ida.Future<_isssl1tb.AppWish> markSatisfied(int id) =>
      caller.callServerEndpoint<_isssl1tb.AppWish>(
        'wish',
        'markSatisfied',
        {'id': id},
      );

  /// Reopens the loop after it was marked satisfied.
  _ida.Future<_isssl1tb.AppWish> reopenWish(int id) =>
      caller.callServerEndpoint<_isssl1tb.AppWish>(
        'wish',
        'reopenWish',
        {'id': id},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_core = _iacc.Caller(client);
    serverpod_auth_idp = _iaic.Caller(client);
  }

  late final _iacc.Caller serverpod_auth_core;

  late final _iaic.Caller serverpod_auth_idp;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    build = EndpointBuild(this);
    builder = EndpointBuilder(this);
    feedback = EndpointFeedback(this);
    greeting = EndpointGreeting(this);
    storeApp = EndpointStoreApp(this);
    wish = EndpointWish(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointBuild build;

  late final EndpointBuilder builder;

  late final EndpointFeedback feedback;

  late final EndpointGreeting greeting;

  late final EndpointStoreApp storeApp;

  late final EndpointWish wish;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'build': build,
    'builder': builder,
    'feedback': feedback,
    'greeting': greeting,
    'storeApp': storeApp,
    'wish': wish,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_core': modules.serverpod_auth_core,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
  };
}
