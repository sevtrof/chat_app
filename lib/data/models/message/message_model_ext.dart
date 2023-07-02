import 'package:chat_app/data/models/message/message_model.dart';
import 'package:chat_app/domain/entities/message.dart';

extension MessageModelExtension on MessageModel {
  Message toDomain() {
    return Message(
      id: id,
      message: message,
      modifiedAt: modifiedAt,
      sender: sender,
    );
  }
}
