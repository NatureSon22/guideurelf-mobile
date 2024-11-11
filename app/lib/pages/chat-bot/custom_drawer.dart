import 'package:app/data/chat_instance.dart';
import 'package:app/pages/chat-bot/chat_history.dart';
import 'package:app/pages/chat-personnel/chat_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  void handleCreateConversation(WidgetRef ref) {
    ref.read(chatInstance.notifier).state = {};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 15.0, left: 10.0, right: 10.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.menu)),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      handleCreateConversation(ref);
                    },
                    icon: const Icon(Icons.create),
                  ),
                ]),
          ),
          const Expanded(child: ChatHistory()),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatMain()));
            },
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(vertical: 13),
              color: Colors.blue.shade500,
              child: const Text(
                "View Messages",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
