import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nftnotes/constants/routes.dart';
import 'package:nftnotes/helper/loading/loading_screen.dart';
import 'package:nftnotes/services/auth/bloc/auth_bloc.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';
import 'package:nftnotes/services/auth/firebase_auth_provider.dart';
import 'package:nftnotes/views/login_view.dart';
import 'package:nftnotes/views/register_view.dart';
import 'package:nftnotes/views/verify_email_view.dart';
import 'audio/recorder.dart';
import 'notes/create_update_note_view.dart';
import 'notes/note_view.dart';
import 'views/forgot_password_view.dart';

void main() {
  runApp(
    MaterialApp(
            debugShowCheckedModeBanner: false,
      title: 'NFT NOTE App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
                recordingStatus : (context) =>  const   RecorderHomeView(title: 'Voice Notes'),

      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
            //            text: state.loadingText   ?? 'Please wait a moment'  ,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLogOut) {
          return const LoginView();
        } else if (state is AuthStateForgetPassword) {
          return const ForgetPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


// A futureBuider we use before BlocBuilder
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }




















// A Simple Counter App
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('BlocTesting'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('Current value => ${state.value}'),
//                 Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child: Text('Invalid Input: $invalidValue'),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter a number here:',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     FloatingActionButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecreamentEvent(_controller.text));
//                       },
//                       backgroundColor: Colors.white,
//                       child: const Icon(
//                         color: Colors.black,
//                         Icons.remove,
//                       ),
//                     ),
//                     FloatingActionButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncreamentEvent(_controller.text));
//                       },
//                       backgroundColor: Colors.white,
//                       child: const Icon(
//                         color: Colors.black,
//                         Icons.add,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//           listener: (context, state) {
//             _controller.clear();
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValid,
//   }) : super(previousValid);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncreamentEvent extends CounterEvent {
//   const IncreamentEvent(String value) : super(value);
// }

// class DecreamentEvent extends CounterEvent {
//   const DecreamentEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncreamentEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValid: state.value,
//           ),
//         );
//       } else {
//         emit(
//           CounterStateValid(state.value + integer),
//         );
//       }
//     });

//     on<DecreamentEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidValue: event.value,
//               previousValid: state.value,
//             ),
//           );
//         } else {
//           emit(
//             CounterStateValid(state.value - integer),
//           );
//         }
//       },
//     );
//   }
// }






