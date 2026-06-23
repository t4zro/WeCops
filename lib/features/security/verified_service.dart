import 'package:cloud_firestore/cloud_firestore.dart';

class VerifiedService {
  static Future<void> checkAndVerify(String uid) async {
    final users = await FirebaseFirestore.instance.collection("users").get();

    if (users.docs.length == 1) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "verified": true
      });
    }
  }
}
