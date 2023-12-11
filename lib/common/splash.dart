import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/auth/signup/name.dart';
import 'package:threads/helper/enum.dart';
import 'package:threads/pages/home.dart';
import 'package:threads/state/auth.state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Provider.of<AuthState>(context).authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement si nécessaire
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            // L'utilisateur est connecté
            return const HomePage();
          } else {
            // L'utilisateur n'est pas connecté
            return const NamePage();
          }
        }
      },
    );
  }
}

Widget _body() {
  return Container();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: _body(),
  );
}
