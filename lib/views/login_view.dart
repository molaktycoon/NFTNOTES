import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/auth_exceptions.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/utilities/dialogs/error_dialog.dart';
import '../services/auth/bloc/auth_event.dart';
import '../ui/widgets/button_widget.dart';
import '../ui/widgets/shared/globals.dart';
import '../ui/widgets/wave_widget.dart';

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
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
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
            await showErrorDialog(
                context, 'Cannot find  a user  wth the entered credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Global.white,
        body: Stack(
          children: <Widget>[
            Container(
              height: size.height - 200,
              color: Global.mediumBlue,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuad,
              top: keyboardOpen ? -size.height / 3.7 : 0.0,
              child: WaveWidget(
                size: size,
                yOffset: size.height / 3.0,
                color: Global.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Global.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // const Text('Please log in to your account in order to interact with  and create nots!'),

                  TextField(
                    obscureText: false,
                    cursorColor: Global.mediumBlue,
                    style: const TextStyle(
                      color: Global.mediumBlue,
                      fontSize: 18.0,
                    ),
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Global.mediumBlue),
                      focusColor: Global.mediumBlue,
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Global.mediumBlue),
                      ),
                      prefixIcon: const Icon(
                        Icons.mail_outline,
                        size: 18,
                        color: Global.mediumBlue,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Global.mediumBlue,
                    style: const TextStyle(
                      color: Global.mediumBlue,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Global.mediumBlue),
                        focusColor: Global.mediumBlue,
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Global.mediumBlue),
                        ),
                        // prefixIcon:  Icon(Icons.security),

                        prefixIcon: const Icon(
                          Icons.lock_clock_outlined,
                          size: 18,
                          color: Global.mediumBlue,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // model.isVisible = !model.isVisible;
                          },
                          child: const Icon(
                            Icons.remove_red_eye,
                          ),
                        )),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventForgetPassword());
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Global.mediumBlue,
                        ),
                      ),
                    ),
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
                    child: const ButtonWidget(
                      title: 'Login',
                      hasBorder: false,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
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
                    child: const ButtonWidget(
                      title: 'Sign Up',
                      hasBorder: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
