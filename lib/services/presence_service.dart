import 'package:firebase_database/firebase_database.dart';

class PresenceService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  late String relationshipId;
  late String userId;

  void init({
    required String relationshipId,
    required String userId,
  }) {
    this.relationshipId = relationshipId;
    this.userId = userId;
  }

  /// ONLINE
  Future<void> setOnline() async {
    final ref = _db
        .ref()
        .child('presence/$relationshipId/$userId');

    await ref.set({
      'status': 'online',
      'lastSeen': ServerValue.timestamp,
    });

    ref.onDisconnect().set({
      'status': 'offline',
      'lastSeen': ServerValue.timestamp,
    });
  }

  /// OFFLINE
  Future<void> setOffline() async {
    await _db
        .ref()
        .child('presence/$relationshipId/$userId')
        .set({
      'status': 'offline',
      'lastSeen': ServerValue.timestamp,
    });
  }

  /// LISTEN PARTNER
  Stream<Map<String, dynamic>> listenPartner(String partnerId) {
    return _db
        .ref()
        .child('presence/$relationshipId/$partnerId')
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) return {'status': 'offline'};
      return Map<String, dynamic>.from(data as Map);
    });
  }
}
