import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, String> getUrls({String id = ""}) {
  return {
    "CREATE_CONVERSATION": "https://getcody.ai/api/v1/conversations",
    "GET_CONVERSATIONS": "https://getcody.ai/api/v1/conversations",
    "GET_MESSAGES": "https://getcody.ai/api/v1/messages?conversation_id=$id",
    "SEND_MESSAGE": "https://getcody.ai/api/v1/messages",
    "DELETE_CONVERSATIONS": "https://getcody.ai/api/v1/conversations/$id",
  };
}

String? bearerToken = dotenv.env['CODY_KEY'];
Map<String, String> headers = {
  "Authorization": "Bearer $bearerToken",
  "Content-Type": "application/json",
};
