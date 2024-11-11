import 'package:app/data/last_message.dart';
import 'package:app/pages/chat-personnel/chat_main.dart';
import 'package:app/service/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageDepartment extends ConsumerStatefulWidget {
  const MessageDepartment({super.key});

  @override
  ConsumerState<MessageDepartment> createState() => _MessageDepartmentState();
}

class _MessageDepartmentState extends ConsumerState<MessageDepartment> {
  final ChatService _service = ChatService();

  void sendMessageToDepartment(String departmentUID, String message) async {
    print(message);
    print("print");
    if (message.isEmpty) return;

    try {
      String docId = await _service.createMessage(departmentUID);
      await _service.sendMessage(docId, message, "user");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatMain()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finalMessageRef = ref.watch(finalMessage);

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 45),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.4,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text(
                "I'm sorry, I don't have information for that query. Feel free to ask more questions or connect to the relevant departments: "),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => sendMessageToDepartment(
                      "McKtCyGQqLhPeSyChpHqB4Lqj8x2", finalMessageRef),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "DEAN",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  //sRpCbmqEgPQo5QU1hjWEp8PIymN2
                   onTap: () => sendMessageToDepartment(
                      "sRpCbmqEgPQo5QU1hjWEp8PIymN2", finalMessageRef),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "REGISTRAR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "MIS",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
