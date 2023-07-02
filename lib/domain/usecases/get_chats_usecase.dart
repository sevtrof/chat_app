import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class GetChatsUsecase {
  final ChatRepository repository;

  GetChatsUsecase(this.repository);

  Future<List<Chat>> execute() async {
    return await repository.fetchChats();
  }
}
