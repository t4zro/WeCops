import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RelationshipService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // =========================
  // CREATE RELATIONSHIP
  // =========================
  Future<String> createRelationship() async {
    final uid = _auth.currentUser!.uid;

    final code = _generateCode();

    final doc = await _firestore.collection("relationships").add({
      "code": code,
      "users": [uid],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await _firestore.collection("users").doc(uid).update({
      "relationshipId": doc.id,
    });

    return code;
  }

  // =========================
  // JOIN RELATIONSHIP
  // =========================
  Future<void> joinRelationship(String code) async {
    final uid = _auth.currentUser!.uid;

    final query = await _firestore
        .collection("relationships")
        .where("code", isEqualTo: code)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Invalid code");
    }

    final doc = query.docs.first;
    final data = doc.data();

    List users = data["users"];

    if (users.length >= 2) {
      throw Exception("Already full (2 users only)");
    }

    users.add(uid);

    await doc.reference.update({"users": users});

    await _firestore.collection("users").doc(uid).update({
      "relationshipId": doc.id,
    });
  }

  // =========================
  // GET MY RELATIONSHIP
  // =========================
  Stream<DocumentSnapshot> myRelationship() {
    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection("relationships")
        .where("users", arrayContains: uid)
        .snapshots()
        .map((snap) => snap.docs.first);
  }

  // =========================
  // CODE GENERATOR
  // =========================
  String _generateCode() {
    const words = [
      "Sun", "Moon", "Star", "Sky", "Love", "Heart", "Dream", "Cloud"
    ];

    final r = Random();
    return "${words[r.nextInt(words.length)]}-${words[r.nextInt(words.length)]}-${r.nextInt(9999)}";
  }
}
