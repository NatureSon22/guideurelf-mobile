import 'package:app/service/rag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Initialize Dio with your headers
final dioProvider = Provider((ref) => Dio(BaseOptions(headers: headers)));

// StateProvider to hold metadata for the selected conversation
final chatInstance = StateProvider<Map<String, dynamic>>((ref) => {});

// FutureProvider to fetch messages for the selected conversation ID
final messagesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final chatMetadata = ref.watch(chatInstance);
  final conversationId = chatMetadata["id"];

  if (chatMetadata.isEmpty) {
    return []; // Return an empty list if there's no selected conversation
  }

  try {
    final dio = ref.read(dioProvider); // Access Dio instance
    final response =
        await dio.get(getUrls(id: conversationId)["GET_MESSAGES"]!);

    // Parse and return the list of messages
    final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data']);
    return data;
  } catch (e) {
    return []; // Return an empty list in case of an error
  }
});
