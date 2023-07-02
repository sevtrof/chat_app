class Chat {
  final String id;
  final String lastMessage;
  final List<String> members;
  final String topic;
  final int modifiedAt;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.members,
    required this.topic,
    required this.modifiedAt,
  });
}
