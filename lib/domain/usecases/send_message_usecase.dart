import 'package:chat_app/domain/entities/message.dart';

class SendMessageUsecase {
  Future<Message> execute(String chatId, String message) async {
    final responseMessage = Message(
      id: chatId,
      message: message,
      modifiedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      sender: 'user',
    );

    return responseMessage;
  }
}
