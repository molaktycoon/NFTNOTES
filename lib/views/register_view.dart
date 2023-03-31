import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/auth_exceptions.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Fail to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Register'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Email here'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Password Here'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventRegister(
                      email,
                      password,
                    ));

                //we use try catch statement here before
                // try {
                //   await AuthService.firebase().createUser(
                //     email: email,
                //     password: password,
                //   );
                //   AuthService.firebase().sendEmailVerification();
                //   if (!mounted) return;
                //   Navigator.of(context).pushNamed(verifyEmailRoute);
                // } on WeakPasswordAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Weak Password',
                //   );
                // } on EmailAlreadyInUseAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Email is already in use',
                //   );
                // } on InvalidEmailAuthException {
                //   await showErrorDialog(
                //     context,
                //     'This is an invalid email address',
                //   );
                // } on GenericAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Failed to register',
                //   );
                // }
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut(),);
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text(
                'Already Registered? Login Here!',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
