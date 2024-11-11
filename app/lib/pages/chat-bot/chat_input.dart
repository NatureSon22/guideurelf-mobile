import 'dart:math';
import 'package:app/data/chat_instance.dart';
import 'package:app/data/last_message.dart';
import 'package:app/service/rag_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInput extends ConsumerStatefulWidget {
  final Function addConversation;
  const ChatInput({super.key, required this.addConversation});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;
  Map<String, dynamic> _newChatInstance = {};

  Future<void> addConversation(String conversationId) async {
    if (_controller.text.isEmpty) return;

    ref.read(finalMessage.notifier).state = _controller.text;
    // Create a new conversation if the ID is empty
    if (conversationId.isEmpty &&
        _controller.text.trim().isNotEmpty &&
        _newChatInstance.isEmpty) {
      await _createNewConversation();
    } else if (_controller.text.trim().isNotEmpty) {
      await _sendMessage(conversationId);
    }
  }

  Future<void> _createNewConversation() async {
    final conversation = {
      "id": Random().nextInt(1000).toString(),
      "content": _controller.text.trim(),
      "machine": false,
      "conversation_id": null,
      "failed_responding": true,
      "flagged": true,
      "created_at": DateTime.now().millisecondsSinceEpoch,
    };

    widget.addConversation(conversation);
    _controller.clear();

    try {
      final botId = dotenv.env['BOT_ID'];
      if (botId == null) {
        return;
      }

      final newInstance = await createConversation({
        "name": conversation["content"],
        "bot_id": botId,
      });

      _newChatInstance = newInstance;

      setState(() => _isSending = true);
      final message = await sendMessage({
        "conversation_id": newInstance["id"],
        "content": conversation["content"],
      });
      widget.addConversation(message);
    } catch (e) {
      print("Failed to create new conversation: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _sendMessage(String conversationId) async {
    final conversation = {
      "id": Random().nextInt(1000).toString(),
      "content": _controller.text.trim(),
      "conversation_id":
          conversationId.isNotEmpty ? conversationId : _newChatInstance["id"],
      "machine": false,
      "failed_responding": true,
      "flagged": true,
      "created_at": DateTime.now().millisecondsSinceEpoch,
    };

    widget.addConversation(conversation);
    _controller.clear();

    setState(() => _isSending = true);

    try {
      final message = await sendMessage({
        "conversation_id":
            conversationId.isNotEmpty ? conversationId : _newChatInstance["id"],
        "content": conversation["content"],
      });
      widget.addConversation(message);
    } catch (e) {
      print("Failed to send message: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRef = ref.watch(chatInstance);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                    addConversation(chatRef["id"] ?? "");
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
                : Icon(
                    Icons.send,
                    color: Colors.blue.shade900,
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
