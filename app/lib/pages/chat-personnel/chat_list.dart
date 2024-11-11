import 'package:app/components/chat_tile.dart';
import 'package:app/data/userinfo.dart';
import 'package:app/service/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatList extends ConsumerStatefulWidget {
  final String docId;
  const ChatList({super.key, required this.docId});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ChatService _service = ChatService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final String userRole = ref.read(userInfo)["role"];

    return StreamBuilder(
      stream: _service.getMessages(widget.docId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        

        if (!snapshot.hasData && snapshot.data.isEmpty) {
          return const Center(child: Text("No conversations yet!"));
        }

        // call markMessagesAsRead only once when data is first loaded
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _service.markMessagesAsRead(widget.docId, userRole);
          });
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final message = snapshot.data[index];
            bool isSender = message['senderId'] == _auth.currentUser!.uid;
            String text = message['text'];
            return ChatTile(text: text, isSender: isSender);
          },
        );
      },
    );
  }
}
