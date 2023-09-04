import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notsify/constants/routes.dart';
import 'package:notsify/services/auth/bloc/auth_bloc.dart';
import 'package:notsify/services/auth/bloc/auth_event.dart';
import 'package:notsify/services/auth/bloc/auth_state.dart';
import 'package:notsify/services/auth/firebase_auth_provider.dart';
import 'package:notsify/views/login_view.dart';
import 'package:notsify/views/notes/create_update_note_view.dart';
import 'package:notsify/views/notes/notes_view.dart';
import 'package:notsify/views/register_view.dart';
import 'views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // primarySwatch: Colors.blue,
      //useMaterial3: true,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        //using switch (state.runtimeType) is the same if I used if (state is AuthStateLoggedIn) {} etc
        switch (state.runtimeType) {
          case AuthStateLoggedIn:
            return const NotesView();
          case AuthStateNeedVerification:
            return const VerifyEmailView();
          case AuthStateLoggedOut:
            return const LoginView();
          case AuthStateRegistering:
            return const RegisterView();
          default:
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
