import 'package:app/data/userinfo.dart';
import 'package:app/pages/chat-personnel/chat_with_department.dart';
import 'package:app/service/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepartmentsChat extends ConsumerStatefulWidget {
  final String departmentUID;
  const DepartmentsChat({super.key, required this.departmentUID});

  @override
  ConsumerState<DepartmentsChat> createState() => _DepartmentsChatState();
}

class _DepartmentsChatState extends ConsumerState<DepartmentsChat> {
  final ChatService _service = ChatService();
  final TextEditingController _controller = TextEditingController();

  Future<String?> createChat(BuildContext context, String userRole) async {
    String? docId;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text("New message"),
                TextField(controller: _controller),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Create'),
              onPressed: () async {
                try {
                  // Perform the async operation and close the dialog.
                  docId = await _service.createMessage(widget.departmentUID);
                  await _service.sendMessage(
                      docId!, _controller.text, userRole);

                  if (mounted) {
                    _controller.clear();
                    Navigator.of(context).pop(); // Close the dialog
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send message: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
    return docId; // Return the document ID after the dialog is closed
  }

  @override
  Widget build(BuildContext context) {
    String userRole = ref.read(userInfo)["role"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String? docId = await createChat(context, userRole);

                if (mounted && docId != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatWithDepartment(
                        departmentUID: widget.departmentUID,
                        docId: docId,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: StreamBuilder(
        stream: _service.getChatsDepartment(widget.departmentUID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Fetching Chats..."));
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No chats found!"));
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final departmentData = snapshot.data[index];
              final time = departmentData["lastMessageTimestamp"];
              final docId = departmentData["docId"];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatWithDepartment(
                                departmentUID: widget.departmentUID,
                                docId: docId,
                              ))),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  tileColor: Colors.grey.shade300,
                  title: Text(time.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
