import 'package:chat_app/domain/entities/message.dart';

class SendMessageUsecase {
  Future<Message> execute(String chatId, String message, String sender) async {
    final responseMessage = Message(
      id: chatId,
      message: message,
      modifiedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      sender: sender,
    );

    return responseMessage;
  }
}
