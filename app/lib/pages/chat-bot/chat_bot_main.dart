import 'package:app/data/userinfo.dart';
import 'package:app/pages/chat-bot/chat_input.dart';
import 'package:app/data/chat_instance.dart';
import 'package:app/pages/chat-bot/chat_conversations.dart';
import 'package:app/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInterface extends ConsumerStatefulWidget {
  const ChatInterface({super.key});

  @override
  ConsumerState<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends ConsumerState<ChatInterface> {
  final List<Map<String, dynamic>> _conversations = List.empty(growable: true);
  final List<Map<String, dynamic>> _newConversations =
      List.empty(growable: true);

  void addConversation(Map<String, dynamic> conversation) {
    print("Adding conversation: $conversation");
    setState(() {
      _newConversations.add(conversation);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the `messagesProvider` to handle chat conversations
    final messageRef = ref.watch(messagesProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
      child: Column(
        children: [
          Expanded(
            child: messageRef.when(
              data: (conversations) {
                _conversations.clear();
                _conversations
                    .addAll([...conversations.reversed, ..._newConversations]);

                return _conversations.isEmpty
                    ? const Center(child: Text("Start a conversation"))
                    : ChatConversations(conversations: _conversations);
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () {
                _newConversations.clear();
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          ChatInput(
            addConversation: addConversation,
          ),
        ],
      ),
    );
  }
}
