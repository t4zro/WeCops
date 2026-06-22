import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? relationshipId;
  final String? partnerId;
  final bool liveWindowEnabled;
  final DateTime? lastSeen;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.relationshipId,
    this.partnerId,
    this.liveWindowEnabled = false,
    this.lastSeen,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      relationshipId: data['relationshipId'],
      partnerId: data['partnerId'],
      liveWindowEnabled: data['liveWindowEnabled'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'relationshipId': relationshipId,
      'partnerId': partnerId,
      'liveWindowEnabled': liveWindowEnabled,
      'lastSeen': FieldValue.serverTimestamp(),
    };
  }
}
