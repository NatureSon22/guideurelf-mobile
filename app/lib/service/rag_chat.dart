import 'package:app/service/rag.dart';
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(headers: headers));

// Fetch all conversations
Future<List<Map<String, dynamic>>> getConversations() async {
  try {
    final response = await dio.get(getUrls()["GET_CONVERSATIONS"]!);

    // Access 'data' from the response
    final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data']);

    return data;
  } catch (e) {
    print("Error fetching conversations: $e");
    return [];
  }
}

// Fetch messages by conversation ID
Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
  try {
    final response =
        await dio.get(getUrls(id: conversationId)["GET_MESSAGES"]!);

    final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data']);

    return data;
  } catch (e) {
    return [];
  }
}

// Create a new conversation
Future<Map<String, dynamic>> createConversation(
    Map<String, dynamic> body) async {
  try {
    final response = await dio.post(
      getUrls()["CREATE_CONVERSATION"]!,
      data: body,
    );

    print(response.data);
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data['data']);

    return data;
  } catch (e) {
    print("Error creating conversation: $e");
    return {};
  }
}

// Send a message within a conversation
Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async {
  try {
    final response = await dio.post(
      getUrls()["SEND_MESSAGE"]!,
      data: body,
    );

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data['data']);

    return data;
  } catch (e) {
    print("Error sending message: $e");
    return {};
  }
}

// Delete a conversation by ID
Future<void> deleteConversation(String conversationId) async {
  try {
    final response =
        await dio.delete(getUrls(id: conversationId)["DELETE_CONVERSATIONS"]!);
    print(response.data);
  } catch (e) {
    print("Error deleting conversation: $e");
  }
}
