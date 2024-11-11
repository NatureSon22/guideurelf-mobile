import 'package:app/pages/chat-personnel/departments.dart';
import 'package:app/service/auth.dart';
import 'package:flutter/material.dart';

class ChatMain extends StatelessWidget {
  ChatMain({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _auth.signOut, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Departments(),
    );
  }
}
