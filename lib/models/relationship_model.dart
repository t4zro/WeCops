import 'package:cloud_firestore/cloud_firestore.dart';

class RelationshipModel {
  final String id;
  final String code;
  final List<String> users;
  final DateTime? createdAt;

  RelationshipModel({
    required this.id,
    required this.code,
    required this.users,
    this.createdAt,
  });

  factory RelationshipModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RelationshipModel(
      id: doc.id,
      code: data['code'] ?? '',
      users: List<String>.from(data['users'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'users': users,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
} 
