import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class GetMessagesUsecase {
  final ChatRepository repository;

  GetMessagesUsecase(this.repository);

  Future<List<Message>> execute(String conversationId) async {
    return await repository.fetchMessages(conversationId);
  }
}
