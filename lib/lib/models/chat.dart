// lib/models/chat_message.dart
class ChatMessage {
  final String id;
  final String senderId;
  final String senderModel;
  final String receiverId;
  final String receiverModel;
  final String message;
  final DateTime timestamp;

  var isRead =true;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderModel,
    required this.receiverId,
    required this.receiverModel,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      senderId: json['sender'],
      senderModel: json['senderModel'],
      receiverId: json['receiver'],
      receiverModel: json['receiverModel'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
