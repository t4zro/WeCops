import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// STREAM FEED
  Stream<List<Post>> getFeed(String relationshipId) {
    return _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Post.fromFirestore(doc)).toList(),
        );
  }

  /// CREATE POST
  Future<void> createPost({
    required String relationshipId,
    required String authorId,
    required String authorName,
    File? imageFile,
    String? caption,
  }) async {
    final postId = const Uuid().v4();
    String? imageUrl;

    if (imageFile != null) {
      final ref = _storage
          .ref()
          .child('posts/$relationshipId/$postId.jpg');

      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final post = Post(
      id: postId,
      authorId: authorId,
      authorName: authorName,
      imageUrl: imageUrl,
      caption: caption,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('posts')
        .doc(postId)
        .set(post.toFirestore());
  }

  /// REACT TO POST
  Future<void> toggleReaction({
    required String relationshipId,
    required String postId,
    required String userId,
    required String emoji,
  }) async {
    final ref = _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('posts')
        .doc(postId);

    final doc = await ref.get();
    final data = doc.data() ?? {};

    final reactions = Map<String, String>.from(data['reactions'] ?? {});

    if (reactions[userId] == emoji) {
      reactions.remove(userId);
    } else {
      reactions[userId] = emoji;
    }

    await ref.update({'reactions': reactions});
  }
}
