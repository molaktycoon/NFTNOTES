import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/services/auth/auth_exceptions.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/utilities/dialogs/error_dialog.dart';

import '../ui/widgets/button_widget.dart';
import '../ui/widgets/shared/globals.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
   bool _passwordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordVisible = true;
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
                  backgroundColor:Global.mediumBlue,
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter your email and password to see your note'),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
          
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter Your Email here'),
                ),
                TextField(
                  controller: _password,
                  obscureText: _passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                       InputDecoration(hintText: 'Enter Your Password Here',
                      // prefixIcon:  Icon(Icons.security),
                           suffixIcon: IconButton(
                        
                            icon:  Icon(
                             _passwordVisible 
                             ? Icons.visibility 
                             : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          )
                      ),
                ),
                Center(
                  child: Column(
                    children: [
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
                        child: 
                         const ButtonWidget(
                        title: 'Register',
                        hasBorder: false,
                      ),
                        
                      ),
                   TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut(),);
                    
                    // Navigator.of(context)
                    //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child:
                       const ButtonWidget(
                        title: 'Already Registered? Login Here!',
                        hasBorder: true,
                      ),
                  
                   
                )
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
