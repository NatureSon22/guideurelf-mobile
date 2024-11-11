import 'package:app/pages/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Message extends StatefulWidget {
  final MessageModel message;
  const Message({super.key, required this.message});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.message.machine
          ? const EdgeInsets.only(right: 30)
          : const EdgeInsets.only(left: 30),
      alignment:
          widget.message.machine ? Alignment.centerLeft : Alignment.centerRight,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.message.machine
              ? Colors.grey.shade200
              : Colors.blue.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        // Use MarkdownBody to render Markdown content
        child: MarkdownBody(
          data: widget.message.content,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color:
                  widget.message.machine ? Colors.grey.shade700 : Colors.white,
              fontSize: 14,
            ),
            // Additional style adjustments if needed
          ),
          selectable: true, // Allows user to select and copy text
        ),
      ),
    );
  }
}
