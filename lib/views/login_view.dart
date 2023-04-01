import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLogOut) {
          // final closeDialog = _closeDialogHandle;
          // if (!state.isLoading && closeDialog != null) {
          //   closeDialog();
          //   _closeDialogHandle = null;
          // } else if (state.isLoading && closeDialog == null) {
          //   _closeDialogHandle = showLoadingDialog(
          //     context: context,
          //     text: 'Loading...',
          //   );
          // }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Cannot find  a user  wth the entered credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
                    child: Column(

            children: [
              const Text('Please log in to your account in order to interact with  and create nots!'),
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
              TextButton(
                onPressed: () {
                 
                  context.read<AuthBloc>().add(
                       const AuthEventShouldRegister(),
                      );
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   registerRoute,
                  //   (route) => false,
                  // );
                },
                child: const Text(
                  'Not Register Yet? Register Here!',
                  style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 20.0,
                    color: Colors.red,
                  ),
                ),
              ),
               TextButton(
                onPressed: () {
                     context.read<AuthBloc>().add(const AuthEventForgetPassword());
                
                },
                child: const Text(
                  'I forgot my password',
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
      ),
    );
  }
}
