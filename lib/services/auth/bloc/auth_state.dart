
import 'package:flutter/foundation.dart';
import 'package:nftnotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}


class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLogOut extends AuthState {
  final Exception? exception;
  const AuthStateLogOut(this.exception);
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}


