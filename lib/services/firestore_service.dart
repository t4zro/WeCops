import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/message_model.dart';
import '../models/story_model.dart';
import '../models/relationship_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================
  // USERS
  // =========================

  CollectionReference get _users =>
      _firestore.collection("users");

  Future<void> createUser(AppUser user) async {
    await _users.doc(user.uid).set(user.toFirestore());
  }

  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.uid).update(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) return null;

    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser?> userStream(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc);
    });
  }

  // =========================
  // RELATIONSHIP
  // =========================

  CollectionReference get _relationships =>
      _firestore.collection("relationships");

  Future<void> createRelationship(
      RelationshipModel relationship) async {
    await _relationships
        .doc(relationship.id)
        .set(relationship.toFirestore());
  }

  Future<RelationshipModel?> getRelationship(
      String id) async {
    final doc = await _relationships.doc(id).get();

    if (!doc.exists) return null;

    return RelationshipModel.fromFirestore(doc);
  }

  Future<void> updateRelationship(
      String id,
      Map<String, dynamic> data,
      ) async {
    await _relationships.doc(id).update(data);
  }

  // =========================
  // POSTS
  // =========================

  CollectionReference posts(String relationshipId) {
    return _relationships
        .doc(relationshipId)
        .collection("posts");
  }

  Future<void> addPost(
      String relationshipId,
      Post post,
      ) async {
    await posts(relationshipId)
        .doc(post.id)
        .set(post.toFirestore());
  }

  Future<void> deletePost(
      String relationshipId,
      String postId,
      ) async {
    await posts(relationshipId).doc(postId).delete();
  }

  Stream<List<Post>> getPosts(
      String relationshipId,
      ) {
    return posts(relationshipId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => Post.fromFirestore(e))
        .toList());
  }

  Future<void> updatePost(
      String relationshipId,
      String postId,
      Map<String, dynamic> data,
      ) async {
    await posts(relationshipId)
        .doc(postId)
        .update(data);
  }

  // =========================
  // STORIES
  // =========================

  CollectionReference stories(String relationshipId) {
    return _relationships
        .doc(relationshipId)
        .collection("stories");
  }

  Future<void> addStory(
      String relationshipId,
      StoryModel story,
      ) async {
    await stories(relationshipId)
        .doc(story.id)
        .set(story.toFirestore());
  }

  Stream<List<StoryModel>> getStories(
      String relationshipId,
      ) {
    return stories(relationshipId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => StoryModel.fromFirestore(e))
        .toList());
  }

  Future<void> deleteStory(
      String relationshipId,
      String storyId,
      ) async {
    await stories(relationshipId)
        .doc(storyId)
        .delete();
  }

  // =========================
  // CHAT
  // =========================

  CollectionReference messages(
      String relationshipId,
      ) {
    return _relationships
        .doc(relationshipId)
        .collection("messages");
  }

  Future<void> sendMessage(
      String relationshipId,
      ChatMessage message,
      ) async {
    await messages(relationshipId)
        .doc(message.id)
        .set(message.toFirestore());
  }

  Stream<List<ChatMessage>> getMessages(
      String relationshipId,
      ) {
    return messages(relationshipId)
        .orderBy("createdAt")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => ChatMessage.fromFirestore(e))
        .toList());
  }

  Future<void> deleteMessage(
      String relationshipId,
      String messageId,
      ) async {
    await messages(relationshipId)
        .doc(messageId)
        .delete();
  }

  Future<void> markMessageRead(
      String relationshipId,
      String messageId,
      ) async {
    await messages(relationshipId)
        .doc(messageId)
        .update({
      "isRead": true,
    });
  }

  // =========================
  // LIKES
  // =========================

  Future<void> likePost(
      String relationshipId,
      String postId,
      String userId,
      ) async {
    await posts(relationshipId)
        .doc(postId)
        .update({
      "likes": FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unlikePost(
      String relationshipId,
      String postId,
      String userId,
      ) async {
    await posts(relationshipId)
        .doc(postId)
        .update({
      "likes": FieldValue.arrayRemove([userId])
    });
  }

  // =========================
  // LAST SEEN
  // =========================

  Future<void> updateLastSeen(
      String uid,
      ) async {
    await _users.doc(uid).update({
      "lastSeen": FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser(
      String uid,
      ) async {
    await _users.doc(uid).delete();
  }
}
