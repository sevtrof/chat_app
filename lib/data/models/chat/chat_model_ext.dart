import 'package:chat_app/data/models/chat/chat_model.dart';
import 'package:chat_app/domain/entities/chat.dart';

extension ChatModelExtension on ChatModel {
  Chat toDomain() {
    return Chat(
      id: id,
      lastMessage: lastMessage,
      members: members,
      topic: topic,
      modifiedAt: modifiedAt,
    );
  }
}
