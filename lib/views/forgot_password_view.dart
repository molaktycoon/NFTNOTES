import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/utilities/dialogs/error_dialog.dart';
import 'package:nftnotes/utilities/dialogs/password_reset_email_send_dialog.dart';

import '../ui/widgets/button_widget.dart';
import '../ui/widgets/shared/globals.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context,
                'We could not process your request. Please make sure you are a register user');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Global.mediumBlue,
          title: const Text('Forget Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please enter the email address on your NFTnotes Account, a password reset link will be send to you'),
              const SizedBox(
                    height: 10.0,
                  ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: 'youremail@here.com',
                    // prefixIcon:  Icon(Icons.security),
                    // suffixIcon: Align(
                    //   widthFactor: 1.0,
                    //   heightFactor: 1.0,
                    //   child: Icon(
                    //     Icons.remove_red_eye,
                    //   ),
                    // )
                    ),
              ),
             const SizedBox(
                    height: 10.0,
                  ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(
                     AuthEventForgetPassword(email: email),
                     );
                },
                child: const ButtonWidget(
                  title: 'Done',
                  hasBorder: false,
                ),
              ),
                const SizedBox(
                    height: 10.0,
                  ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const ButtonWidget(
                  title: 'Back to login page',
                  hasBorder: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
