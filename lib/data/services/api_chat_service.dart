import 'dart:convert';
import 'package:chat_app/data/models/chat/chat_model.dart';
import 'package:chat_app/data/models/message/message_model.dart';
import 'package:http/http.dart' as http;

abstract class ApiChatService {
  Future<List<ChatModel>> fetchConversations();

  Future<List<MessageModel>> fetchMessages(String conversationId);
}

class ApiChatServiceImpl implements ApiChatService {
  final String _baseUrl =
      'https://jefe-stg-media-bucket.s3.amazonaws.com/programming-test/api';

  @override
  Future<List<ChatModel>> fetchConversations() async {
    final response = await http.get(Uri.parse('$_baseUrl/inbox.json'));
    if (response.statusCode == 200) {
      String sanitizedJson = _sanitizeJsonResponse(response.body);
      List<dynamic> parsedJson = jsonDecode(sanitizedJson);
      return parsedJson.map((e) => ChatModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  @override
  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/$conversationId.json'));
    if (response.statusCode == 200) {
      String sanitizedJson = _sanitizeJsonResponse(response.body);
      List<dynamic> parsedJson = jsonDecode(sanitizedJson);
      return parsedJson.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  String _sanitizeJsonResponse(String jsonString) {
    int lastCharacterIndex = jsonString.lastIndexOf(']');
    int insertionIndex = lastCharacterIndex;
    while (jsonString[insertionIndex - 1] == ',' ||
        jsonString[insertionIndex - 1] == ' ') {
      insertionIndex--;
    }
    if (insertionIndex < lastCharacterIndex) {
      return jsonString.substring(0, insertionIndex) +
          jsonString.substring(lastCharacterIndex);
    } else {
      return jsonString;
    }
  }
}
