import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String text;
  final bool isSender;
  const ChatTile({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 17,
        ),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isSender ? const Radius.circular(20) : Radius.zero,
            bottomRight: isSender ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
