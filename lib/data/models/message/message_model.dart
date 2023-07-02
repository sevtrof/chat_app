class MessageModel {
  final String id;
  final String message;
  final int modifiedAt;
  final String sender;

  MessageModel({
    required this.id,
    required this.message,
    required this.modifiedAt,
    required this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      modifiedAt: json['modified_at'],
      sender: json['sender'],
    );
  }
}
