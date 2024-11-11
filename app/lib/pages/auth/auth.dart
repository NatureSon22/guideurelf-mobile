import 'package:app/pages/auth/initialize_info.dart';
import 'package:app/pages/auth/login.dart';
import 'package:app/pages/chat-personnel/chat_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snaphot) {
          if (snaphot.hasData) {
            return const InitializeInfo();
          } else {
            return Login();
          }
        });
  }
}
