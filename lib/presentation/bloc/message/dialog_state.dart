import 'package:chat_app/domain/entities/message.dart';

abstract class DialogState {}

class DialogInitial extends DialogState {}

class DialogLoading extends DialogState {}

class DialogLoaded extends DialogState {
  final List<Message> messages;

  DialogLoaded({required this.messages});
}

class DialogEmpty extends DialogState {}

class DialogError extends DialogState {
  final String message;

  DialogError({required this.message});
}
