import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/entities/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;

  ChatLoaded({required this.chats});
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  MessagesLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});
}
