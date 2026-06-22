import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';

class FeedService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  // =========================
  // GET PRIVATE FEED (ONLY 2 USERS)
  // =========================
  Stream<List<PostModel>> getFeed(String relationshipId) {
    return _firestore
        .collection("relationships")
        .doc(relationshipId)
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((e) => PostModel.fromDoc(e)).toList());
  }

  // =========================
  // UPLOAD POST
  // =========================
  Future<void> createPost({
    required File image,
    required String caption,
    required String relationshipId,
  }) async {
    final uid = _auth.currentUser!.uid;
    final postId = const Uuid().v4();

    // upload image
    final ref = _storage
        .ref()
        .child("posts/$relationshipId/$postId.jpg");

    await ref.putFile(image);

    final url = await ref.getDownloadURL();

    final post = PostModel(
      id: postId,
      userId: uid,
      imageUrl: url,
      caption: caption,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection("relationships")
        .doc(relationshipId)
        .collection("posts")
        .doc(postId)
        .set(post.toMap());
  }
}
