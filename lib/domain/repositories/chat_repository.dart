import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/entities/message.dart';

abstract class ChatRepository {
  Future<List<Chat>> fetchChats();

  Future<List<Message>> fetchMessages(String conversationId);
}
