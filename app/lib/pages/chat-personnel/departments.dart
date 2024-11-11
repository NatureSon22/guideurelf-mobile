import 'package:app/data/userinfo.dart';
import 'package:app/pages/chat-personnel/departments_chat.dart';
import 'package:app/service/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Departments extends ConsumerStatefulWidget {
  const Departments({super.key});

  @override
  ConsumerState<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends ConsumerState<Departments> {
  final ChatService _service = ChatService();

  @override
  Widget build(BuildContext context) {
    // Safely read the 'campus' value from userInfo
    final userInfoState = ref.watch(userInfo);
    String campus =
        userInfoState["campus"] ?? "Default Campus"; // Fallback value if null

    return StreamBuilder(
      stream: _service.getDepartments(campus),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Fetching Departments..."));
        }

        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("No departments available!"));
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final departmentData = snapshot.data[index];
            final departmentUID = departmentData["uid"];
            final email = departmentData["email"] ??
                "No email provided"; // Fallback value
            final position = departmentData["position"];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DepartmentsChat(departmentUID: departmentUID))),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                tileColor: Colors.grey.shade300,
                title: Text(
                  position,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  email,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
