import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  //=========================
  // PROFILE IMAGE
  //=========================

  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final ext = path.extension(file.path);

    final ref = _storage
        .ref()
        .child("users")
        .child(uid)
        .child("profile$ext");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  //=========================
  // POST IMAGE
  //=========================

  Future<String> uploadPostImage({
    required String relationshipId,
    required File file,
  }) async {
    final id = const Uuid().v4();
    final ext = path.extension(file.path);

    final ref = _storage
        .ref()
        .child("relationships")
        .child(relationshipId)
        .child("posts")
        .child("$id$ext");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  //=========================
  // CHAT IMAGE
  //=========================

  Future<String> uploadChatImage({
    required String relationshipId,
    required File file,
  }) async {
    final id = const Uuid().v4();
    final ext = path.extension(file.path);

    final ref = _storage
        .ref()
        .child("relationships")
        .child(relationshipId)
        .child("messages")
        .child("$id$ext");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  //=========================
  // STORY IMAGE
  //=========================

  Future<String> uploadStory({
    required String relationshipId,
    required File file,
  }) async {
    final id = const Uuid().v4();
    final ext = path.extension(file.path);

    final ref = _storage
        .ref()
        .child("relationships")
        .child(relationshipId)
        .child("stories")
        .child("$id$ext");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  //=========================
  // VIDEO
  //=========================

  Future<String> uploadVideo({
    required String relationshipId,
    required File file,
  }) async {
    final id = const Uuid().v4();
    final ext = path.extension(file.path);

    final ref = _storage
        .ref()
        .child("relationships")
        .child(relationshipId)
        .child("videos")
        .child("$id$ext");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  //=========================
  // DELETE FILE
  //=========================

  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (_) {}
  }

  //=========================
  // FILE SIZE
  //=========================

  Future<int> getFileSize(String downloadUrl) async {
    final ref = _storage.refFromURL(downloadUrl);
    final metadata = await ref.getMetadata();

    return metadata.size ?? 0;
  }

  //=========================
  // METADATA
  //=========================

  Future<FullMetadata> getMetadata(
    String downloadUrl,
  ) async {
    final ref = _storage.refFromURL(downloadUrl);

    return await ref.getMetadata();
  }

  //=========================
  // EXISTS
  //=========================

  Future<bool> exists(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).getMetadata();
      return true;
    } catch (_) {
      return false;
    }
  }

  //=========================
  // DOWNLOAD URL
  //=========================

  Future<String> getDownloadUrl(String storagePath) async {
    return await _storage.ref(storagePath).getDownloadURL();
  }
}
