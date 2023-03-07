import 'package:flutter/material.dart';
import 'package:nftnotes/constants/routes.dart';

import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(children: [
        const Text("We've sent you an email verification, Please open to verify your account"),
          const Text("If you haven't received a verification email yet, press the button below"),
          TextButton (onPressed: () async{
            AuthService.firebase().sendEmailVerification();
          }, child: const Text('Send Email Verificaion'),),
          TextButton(onPressed: () async{
            await AuthService.firebase().logOut();
            if (!mounted) return;  
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
          }, child: const Text('Restart'))
         
              ],
           
        ),
    );
  }
}
