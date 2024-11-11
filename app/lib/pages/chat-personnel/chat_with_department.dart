import 'package:app/components/chat_input.dart';
import 'package:app/pages/chat-personnel/chat_list.dart';
import 'package:app/service/chat.dart';
import 'package:flutter/material.dart';

class ChatWithDepartment extends StatelessWidget {
  final String departmentUID;
  final String docId;

  ChatWithDepartment({
    super.key,
    required this.departmentUID,
    required this.docId,
  });

  final ChatService _service = ChatService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _service.checkDepartmentActive(departmentUID),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chat"),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chat"),
              centerTitle: true,
            ),
            body: const Center(
              child: Text(
                "Error loading chat status. Please try again later.",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final isActive = snapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Chat"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: ChatList(docId: docId),
                ),
              ),
              isActive
                  ? ChatInput(docId: docId)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "Chat is currently closed. Please check back during active hours.",
                        style: TextStyle(color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
