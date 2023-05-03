import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';

import '../ui/widgets/button_widget.dart';
import '../ui/widgets/shared/globals.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.mediumBlue,
        title: const Text('Verify Email'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "We've sent you an email verification, Please open to verify your account"),
            const Text(
                "If you haven't received a verification email yet, press the button below"),
            TextButton(
              onPressed: () async {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
                // AuthService.firebase().sendEmailVerification();
              },
              child: const ButtonWidget(
                title: 'Send Email Verificaion',
                hasBorder: false,
              ),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventLogOut());
                // await AuthService.firebase().logOut();
                // if (!mounted) return;
                // Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
              },
              child: const ButtonWidget(
                title: 'Restart',
                hasBorder: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
