import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/constants/routes.dart';
import 'package:nftnotes/services/auth/auth_exceptions.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/utilities/dialogs/error_dialog.dart';

import '../services/auth/bloc/auth_event.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Login'),
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async{
              if (state is AuthStateLogOut) {
                if(state.exception is UserNotFoundAuthException){
                  await showErrorDialog(context, 'User not found');
                } else if(state.exception is WrongPasswordAuthException){
                  await showErrorDialog(context, 'Wrong Credentials');
                }else if (state.exception is GenericAuthException){
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );

                      //we remove the try catch statement
                // try {
                //   context.read<AuthBloc>().add(
                //         AuthEventLogIn(
                //           email,
                //           password,
                //         ),
                //       );
                // } on UserNotFoundAuthException {
                //   await showErrorDialog(
                //     context,
                //     'User not found',
                //   );
                // } on WrongPasswordAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Wrong Credentials',
                //   );
                // } on GenericAuthException {
                //   await showErrorDialog(
                //     context,
                //     'Authentication Error',
                //   );
                // }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  fontSize: 25.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text(
              'Not Register Yet? Register Here!',
              style: TextStyle(
                fontFamily: 'Signatra',
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
