import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, location }

class ChatMessage {
  final String id;
  final String senderId;
  final String? text;
  final String? mediaUrl;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.text,
    this.mediaUrl,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'],
      mediaUrl: data['mediaUrl'],
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'mediaUrl': mediaUrl,
      'type': type.name,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': isRead,
    };
  }
}
