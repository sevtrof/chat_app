class ChatModel {
  final String id;
  final String lastMessage;
  final List<String> members;
  final String topic;
  final int modifiedAt;

  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.members,
    required this.topic,
    required this.modifiedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      lastMessage: json['last_message'],
      members: List<String>.from(json['members']),
      topic: json['topic'],
      modifiedAt: json['modified_at'],
    );
  }
}
