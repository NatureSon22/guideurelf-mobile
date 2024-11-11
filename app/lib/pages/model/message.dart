class MessageModel {
  String id;
  String content;
  String? conversationId;
  bool machine;
  bool failedResponding;
  bool flagged;
  int createdAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.conversationId,
    required this.machine,
    required this.failedResponding,
    required this.flagged,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      conversationId: json['conversation_id'],
      machine: json['machine'],
      failedResponding: json['failed_responding'],
      flagged: json['flagged'],
      createdAt: json['created_at'],
    );
  }
}
