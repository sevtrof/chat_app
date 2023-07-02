abstract class ChatEvent {}

class FetchChats extends ChatEvent {}

class FetchMessages extends ChatEvent {
  final String conversationId;

  FetchMessages(this.conversationId);
}
