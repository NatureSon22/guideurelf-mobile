import 'package:app/data/userinfo.dart';
import 'package:app/pages/chat-bot/chat_bot.dart';
import 'package:app/pages/chat-personnel/chat_main.dart';
import 'package:app/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitializeInfo extends ConsumerStatefulWidget {
  const InitializeInfo({super.key});

  @override
  ConsumerState<InitializeInfo> createState() => _InitializeInfoState();
}

class _InitializeInfoState extends ConsumerState<InitializeInfo> {
  final AuthService _auth = AuthService();

  Future<List<Map<String, dynamic>>> getUserInfo() async {
    return await _auth.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUserInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Update the provider state after data is fetched
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(userInfo.notifier).state = snapshot.data![0];
            });

            // Return the ChatMain widget or navigate to it
            //return ChatMain();
            return const ChatBot();
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
