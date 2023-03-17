import 'package:flutter/material.dart';
import 'package:nftnotes/constants/routes.dart';
import 'package:nftnotes/services/auth/auth_exceptions.dart';
import 'package:nftnotes/services/auth/auth_service.dart';
import 'package:nftnotes/utilities/show_error_diaglog.dart';

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
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //User's email is Verified
                  if (!mounted) return;  
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //User email is NOT verified
                  if (!mounted) return;  
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDiaglog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDiaglog(
                  context,
                  'Wrong Credentials',
                );
              } on GenericAuthException {
                await showErrorDiaglog(
                  context,
                  'Authentication Error',
                );
              }
            },
            child: const Text('Login', 
            style: TextStyle(
              fontFamily: 'Signatra',
              fontSize: 25.0,
              color: Colors.red,
            ) ,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not Register Yet? Register Here!',
             style: TextStyle(
              fontFamily: 'Signatra',
              fontSize: 20.0,
              color: Colors.red,
            ) , ),
              )
        ],
      ),
    );
  }
}
