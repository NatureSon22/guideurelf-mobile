import 'package:app/data/userinfo.dart';
import 'package:app/service/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInput extends ConsumerStatefulWidget {
  final String docId;
  const ChatInput({super.key, required this.docId});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final bool _isSending = false;
  final ChatService _service = ChatService();

  @override
  Widget build(BuildContext context) {
    String userRole = ref.read(userInfo)["role"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: TextField(
        autocorrect: true,
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Type a message',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          suffixIcon: GestureDetector(
            onTap: _isSending
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                  },
            child: _isSending
                ? Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.blue.shade900,
                      strokeWidth: 2,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _service.sendMessage(
                          widget.docId, _controller.text, userRole);
                      _controller.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.blue.shade900,
                    ),
                  ),
          ),
          isDense: true,
        ),
        minLines: 1,
        maxLines: 3,
        autofocus: false,
      ),
    );
  }
}
