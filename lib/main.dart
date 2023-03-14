import 'package:flutter/material.dart';
import 'package:nftnotes/constants/routes.dart';
import 'package:nftnotes/views/login_view.dart';
import 'package:nftnotes/views/verify_email_view.dart';
import 'package:path/path.dart';
import 'notes/new_note_view.dart';
import 'services/auth/auth_service.dart';
import 'notes/note_view.dart';
import 'views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        notesRoute :(context) => const NotesView(),
        verifyEmailRoute :(context) => const VerifyEmailView(),
        newNoteRoute :(context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


