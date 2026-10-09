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
import 'package:apploop_server/src/generated/future_calls.dart' as _i1nmt0s2;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../builds/build_endpoint.dart' as _iu98uiq9;
import '../builds/builder_endpoint.dart' as _infkm04t;
import '../greetings/greeting_endpoint.dart' as _il624ik7;
import '../store/store_app_endpoint.dart' as _iz4r4dl0;
import '../wishes/wish_endpoint.dart' as _i8qgaqst;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'build': _iu98uiq9.BuildEndpoint()
        ..initialize(
          server,
          'build',
          null,
        ),
      'builder': _infkm04t.BuilderEndpoint()
        ..initialize(
          server,
          'builder',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'storeApp': _iz4r4dl0.StoreAppEndpoint()
        ..initialize(
          server,
          'storeApp',
          null,
        ),
      'wish': _i8qgaqst.WishEndpoint()
        ..initialize(
          server,
          'wish',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['build'] = _is.EndpointConnector(
      name: 'build',
      endpoint: endpoints['build']!,
      methodConnectors: {
        'requestBuild': _is.MethodConnector(
          name: 'requestBuild',
          params: {
            'wishId': _is.ParameterDescription(
              name: 'wishId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['build'] as _iu98uiq9.BuildEndpoint).requestBuild(
                    session,
                    params['wishId'],
                  ),
        ),
        'getBuildsForWish': _is.MethodConnector(
          name: 'getBuildsForWish',
          params: {
            'wishId': _is.ParameterDescription(
              name: 'wishId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['build'] as _iu98uiq9.BuildEndpoint)
                  .getBuildsForWish(
                    session,
                    params['wishId'],
                  ),
        ),
        'listMyBuilds': _is.MethodConnector(
          name: 'listMyBuilds',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['build'] as _iu98uiq9.BuildEndpoint)
                  .listMyBuilds(session),
        ),
        'getBuild': _is.MethodConnector(
          name: 'getBuild',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['build'] as _iu98uiq9.BuildEndpoint).getBuild(
                    session,
                    params['id'],
                  ),
        ),
        'retryBuild': _is.MethodConnector(
          name: 'retryBuild',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['build'] as _iu98uiq9.BuildEndpoint).retryBuild(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['builder'] = _is.EndpointConnector(
      name: 'builder',
      endpoint: endpoints['builder']!,
      methodConnectors: {
        'claimBuildTask': _is.MethodConnector(
          name: 'claimBuildTask',
          params: {
            'builderToken': _is.ParameterDescription(
              name: 'builderToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['builder'] as _infkm04t.BuilderEndpoint)
                  .claimBuildTask(
                    session,
                    params['builderToken'],
                  ),
        ),
        'postBuildProgress': _is.MethodConnector(
          name: 'postBuildProgress',
          params: {
            'builderToken': _is.ParameterDescription(
              name: 'builderToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'buildId': _is.ParameterDescription(
              name: 'buildId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'logAppend': _is.ParameterDescription(
              name: 'logAppend',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['builder'] as _infkm04t.BuilderEndpoint)
                  .postBuildProgress(
                    session,
                    params['builderToken'],
                    params['buildId'],
                    params['status'],
                    params['logAppend'],
                  ),
        ),
        'completeBuild': _is.MethodConnector(
          name: 'completeBuild',
          params: {
            'builderToken': _is.ParameterDescription(
              name: 'builderToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'buildId': _is.ParameterDescription(
              name: 'buildId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'succeeded': _is.ParameterDescription(
              name: 'succeeded',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'testflightState': _is.ParameterDescription(
              name: 'testflightState',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'logAppend': _is.ParameterDescription(
              name: 'logAppend',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['builder'] as _infkm04t.BuilderEndpoint)
                  .completeBuild(
                    session,
                    params['builderToken'],
                    params['buildId'],
                    params['succeeded'],
                    params['testflightState'],
                    params['logAppend'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    connectors['storeApp'] = _is.EndpointConnector(
      name: 'storeApp',
      endpoint: endpoints['storeApp']!,
      methodConnectors: {
        'requestApp': _is.MethodConnector(
          name: 'requestApp',
          params: {
            'wishId': _is.ParameterDescription(
              name: 'wishId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['storeApp'] as _iz4r4dl0.StoreAppEndpoint)
                  .requestApp(
                    session,
                    params['wishId'],
                  ),
        ),
        'getStoreAppForWish': _is.MethodConnector(
          name: 'getStoreAppForWish',
          params: {
            'wishId': _is.ParameterDescription(
              name: 'wishId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['storeApp'] as _iz4r4dl0.StoreAppEndpoint)
                  .getStoreAppForWish(
                    session,
                    params['wishId'],
                  ),
        ),
      },
    );
    connectors['wish'] = _is.EndpointConnector(
      name: 'wish',
      endpoint: endpoints['wish']!,
      methodConnectors: {
        'createWish': _is.MethodConnector(
          name: 'createWish',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wish'] as _i8qgaqst.WishEndpoint).createWish(
                    session,
                    params['title'],
                    params['description'],
                  ),
        ),
        'listMyWishes': _is.MethodConnector(
          name: 'listMyWishes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wish'] as _i8qgaqst.WishEndpoint)
                  .listMyWishes(session),
        ),
        'updateWish': _is.MethodConnector(
          name: 'updateWish',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wish'] as _i8qgaqst.WishEndpoint).updateWish(
                    session,
                    params['id'],
                    params['title'],
                    params['description'],
                  ),
        ),
        'deleteWish': _is.MethodConnector(
          name: 'deleteWish',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wish'] as _i8qgaqst.WishEndpoint).deleteWish(
                    session,
                    params['id'],
                  ),
        ),
        'markSatisfied': _is.MethodConnector(
          name: 'markSatisfied',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wish'] as _i8qgaqst.WishEndpoint).markSatisfied(
                    session,
                    params['id'],
                  ),
        ),
        'reopenWish': _is.MethodConnector(
          name: 'reopenWish',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wish'] as _i8qgaqst.WishEndpoint).reopenWish(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i1nmt0s2.FutureCalls();
  }
}
