import 'package:bloc/bloc.dart';
import 'package:nftnotes/services/auth/auth_provider.dart';
import 'package:nftnotes/services/auth/bloc/auth_event.dart';
import 'package:nftnotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    //register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLogOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    //Login
    on<AuthEventLogIn>((event, emit) async {
              emit(const AuthStateLogOut(exception: null, isLoading: true,));

      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateLogOut(exception: null, isLoading: false,),);
          emit(const AuthStateNeedsVerification());
        }else{
          emit(const AuthStateLogOut(exception: null, isLoading: false,),);
                  emit(AuthStateLoggedIn(user));

        }

      } on Exception catch (e) {
        emit( AuthStateLogOut(exception: e, isLoading: false,),);
      }
    });

    //LogOut
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
         emit(const AuthStateLogOut(exception: null, isLoading: false,),);
      } on Exception catch (e) {
        emit(AuthStateLogOut(exception: e, isLoading: false,),);
      }
    });
  }
}
