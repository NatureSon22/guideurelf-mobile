import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final Timestamp time;

  Message({required this.senderId, required this.text, required this.time});

  Map<String, dynamic> get toMap =>
      {"senderId": senderId, "text": text, "time": time};
}
