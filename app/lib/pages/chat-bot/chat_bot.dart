import 'package:app/data/chat_instance.dart';
import 'package:app/pages/chat-bot/chat_bot_main.dart';
import 'package:app/pages/chat-bot/custom_drawer.dart';
import 'package:app/service/rag_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatBot extends ConsumerStatefulWidget {
  const ChatBot({super.key});

  @override
  ConsumerState<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {
  void handleDeleteConversation(WidgetRef ref) async {
    await deleteConversation(ref.read(chatInstance)['id']);

    ref.read(chatInstance.notifier).state = {};
    print('delete');
  }

  @override
  Widget build(BuildContext context) {
    final chatRef = ref.watch(chatInstance);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot"),
        centerTitle: true,
        actions: chatRef.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => handleDeleteConversation(
                      ref), // Call the function with ref
                ),
              ]
            : [],
      ),
      body: const ChatInterface(),
      drawer: const CustomDrawer(),
    );
  }
}
