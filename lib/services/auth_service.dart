import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// LOGIN
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// SIGN UP
  Future<UserCredential> signUp(
    String email,
    String password,
    String name,
  ) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCred.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': name,
        'photoUrl': null,
        'relationshipId': null,
        'partnerId': null,
        'liveWindowEnabled': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }

    return userCred;
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// GET USER DATA
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }
}
