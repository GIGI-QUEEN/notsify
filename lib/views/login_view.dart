import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notsify/constants/routes.dart';
import 'package:notsify/utilities/show_error_dialog.dart';

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
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Eneter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Eneter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'user-not-found':
                    await showErrorDialog(context, 'User not found');
                    break;
                  case 'wrong-password':
                    await showErrorDialog(context, 'Wrong credentials');
                    break;
                  default:
                    await showErrorDialog(context, 'Error ${e.code}');
                    break;
                }
                /* if (e.code == 'user-not-found') {
                            devtools.log("User not found");
                          } */
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here!')),
        ],
      ),
    );
  }
}
