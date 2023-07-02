abstract class DialogEvent {}

class FetchDialog extends DialogEvent {
  final String chatId;

  FetchDialog({required this.chatId});
}

class SendDialogMessage extends DialogEvent {
  final String chatId;
  final String message;

  SendDialogMessage({required this.chatId, required this.message});
}
