import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/service/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService _auth = AuthService();

  void signIn() {
    _auth.signIn(email.text, password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            Input(controller: email),
            const SizedBox(
              height: 15,
            ),
            Input(controller: password),
            const SizedBox(
              height: 30,
            ),
            Button(text: "LOGIN", onTap: signIn)
          ]),
        ),
      ),
    );
  }
}
