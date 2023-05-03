import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut(); 
}
class AuthEventForgetPassword extends AuthEvent {
  final String? email;
const AuthEventForgetPassword ({this.email});
}

class AuthEventAudioRecording extends AuthEvent {
  const AuthEventAudioRecording();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
    final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent {
    const AuthEventShouldRegister();
}  