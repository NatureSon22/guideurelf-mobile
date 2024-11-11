import 'package:app/firebase_options.dart';
import 'package:app/pages/auth/Auth.dart';
import 'package:app/pages/chat-bot/chat_bot.dart';
import 'package:app/pages/chat-personnel/chat_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Auth(),
        "/chat-bot": (context) => const ChatBot(),
        "/chat-personnel": (context) => ChatMain()
      },
    );
  }
}
