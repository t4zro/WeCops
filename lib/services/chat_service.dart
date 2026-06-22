import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// STREAM MESSAGES
  Stream<List<ChatMessage>> getMessages(String relationshipId) {
    return _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatMessage.fromFirestore(doc))
              .toList(),
        );
  }

  /// SEND TEXT MESSAGE
  Future<void> sendText({
    required String relationshipId,
    required String senderId,
    required String text,
  }) async {
    final id = const Uuid().v4();

    final msg = ChatMessage(
      id: id,
      senderId: senderId,
      text: text,
      type: MessageType.text,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('messages')
        .doc(id)
        .set(msg.toFirestore());
  }

  /// SEND IMAGE MESSAGE
  Future<void> sendImage({
    required String relationshipId,
    required String senderId,
    required File file,
  }) async {
    final id = const Uuid().v4();

    final ref = _storage.ref().child(
      'chat/$relationshipId/$id.jpg',
    );

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    final msg = ChatMessage(
      id: id,
      senderId: senderId,
      mediaUrl: url,
      type: MessageType.image,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('messages')
        .doc(id)
        .set(msg.toFirestore());
  }

  /// MARK AS READ
  Future<void> markAsRead({
    required String relationshipId,
    required String messageId,
  }) async {
    await _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
}
