import 'package:chat_app/data/models/chat/chat_model_ext.dart';
import 'package:chat_app/data/models/message/message_model_ext.dart';
import 'package:chat_app/data/services/api_chat_service.dart';
import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiChatService apiDataSource;

  ChatRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Chat>> fetchChats() async {
    final chatModels = await apiDataSource.fetchConversations();
    return chatModels.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<Message>> fetchMessages(String conversationId) async {
    final messageModels = await apiDataSource.fetchMessages(conversationId);
    return messageModels.map((model) => model.toDomain()).toList();
  }
}
