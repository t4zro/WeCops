// ============================================================
// US APP - Complete Consolidated Code
// A private two-person social app (Instagram + Snapchat hybrid)
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

// ============================================================
// MAIN ENTRY POINT
// ============================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: UsApp()));
}

// ============================================================
// APP ROOT
// ============================================================
class UsApp extends StatelessWidget {
  const UsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Us',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// THEME
// ============================================================
class AppTheme {
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryDark = Color(0xFFFF477E);
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkCard = Color(0xFF2C2C2E);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryDark,
        surface: surface,
        background: background,
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: -0.5),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: textSecondary),
        bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF2F2F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primary, width: 2)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryDark,
        surface: darkSurface,
        background: darkBg,
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: textSecondary),
        bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primary, width: 2)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================
class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? relationshipId;
  final String? partnerId;
  final bool liveWindowEnabled;
  final DateTime lastSeen;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.relationshipId,
    this.partnerId,
    this.liveWindowEnabled = false,
    required this.lastSeen,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      relationshipId: data['relationshipId'],
      partnerId: data['partnerId'],
      liveWindowEnabled: data['liveWindowEnabled'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'relationshipId': relationshipId,
    'partnerId': partnerId,
    'liveWindowEnabled': liveWindowEnabled,
    'lastSeen': FieldValue.serverTimestamp(),
  };
}

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String? imageUrl;
  final String? videoUrl;
  final String? caption;
  final String? location;
  final double? latitude;
  final double? longitude;
  final bool isEphemeral;
  final int? durationSeconds;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, String> reactions;
  final List<Comment> comments;
  final bool isSynced;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    this.imageUrl,
    this.videoUrl,
    this.caption,
    this.location,
    this.latitude,
    this.longitude,
    this.isEphemeral = false,
    this.durationSeconds,
    this.createdAt,
    this.expiresAt,
    this.reactions = const {},
    this.comments = const [],
    this.isSynced = false,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'],
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
      caption: data['caption'],
      location: data['location'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      isEphemeral: data['isEphemeral'] ?? false,
      durationSeconds: data['durationSeconds'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null ? (data['expiresAt'] as Timestamp).toDate() : null,
      reactions: Map<String, String>.from(data['reactions'] ?? {}),
      comments: (data['comments'] as List<dynamic>?)?.map((c) => Comment.fromJson(c)).toList() ?? [],
      isSynced: true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatar': authorAvatar,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'caption': caption,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'isEphemeral': isEphemeral,
    'durationSeconds': durationSeconds,
    'createdAt': FieldValue.serverTimestamp(),
    'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    'reactions': reactions,
    'comments': comments.map((c) => c.toJson()).toList(),
  };
}

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] ?? '',
    authorId: json['authorId'] ?? '',
    authorName: json['authorName'] ?? '',
    text: json['text'] ?? '',
    createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorId': authorId,
    'authorName': authorName,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  };
}

class ChatMessage {
  final String id;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final bool isSynced;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.type,
    DateTime? timestamp,
    this.isRead = false,
    this.isSynced = false,
  }) : this.timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'],
      imageUrl: data['imageUrl'],
      type: MessageType.values.firstWhere((e) => e.name == (data['type'] ?? 'text')),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      isSynced: true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'senderId': senderId,
    'text': text,
    'imageUrl': imageUrl,
    'type': type.name,
    'timestamp': FieldValue.serverTimestamp(),
    'isRead': isRead,
  };
}

enum MessageType { text, image, video, sticker, location }

// ============================================================
// SERVICES
// ============================================================
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<User?> signUpWithEmail(String email, String password, String displayName) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await result.user?.updateDisplayName(displayName);
    await _firestore.collection('users').doc(result.user?.uid).set({
      'email': email,
      'displayName': displayName,
      'lastSeen': FieldValue.serverTimestamp(),
      'liveWindowEnabled': false,
    });
    return result.user;
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<String> createRelationship() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Not authenticated');
    final code = _generateCode();
    final relationshipRef = await _firestore.collection('relationships').add({
      'code': code,
      'users': [userId],
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('users').doc(userId).update({
      'relationshipId': relationshipRef.id,
    });
    return code;
  }

  Future<void> joinRelationship(String code) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Not authenticated');
    final snapshot = await _firestore.collection('relationships').where('code', isEqualTo: code).limit(1).get();
    if (snapshot.docs.isEmpty) throw Exception('Invalid code');
    final relationship = snapshot.docs.first;
    final users = List<String>.from(relationship.data()['users'] ?? []);
    if (users.length >= 2) throw Exception('Relationship is full');
    users.add(userId);
    await relationship.reference.update({'users': users});
    await _firestore.collection('users').doc(userId).update({'relationshipId': relationship.id});
    final partnerId = users.firstWhere((id) => id != userId);
    await _firestore.collection('users').doc(userId).update({'partnerId': partnerId});
    await _firestore.collection('users').doc(partnerId).update({'partnerId': userId});
  }

  String _generateCode() {
    final adjectives = ['Sunset', 'Ocean', 'Starlit', 'Golden', 'Silver', 'Crystal', 'Velvet', 'Cosmic', 'Dreamy', 'Mystic'];
    final nouns = ['Piano', 'Guitar', 'Garden', 'Castle', 'Harbor', 'Valley', 'Meadow', 'Canyon', 'Lagoon', 'Temple'];
    final random = Random();
    return '${adjectives[random.nextInt(adjectives.length)]}-${nouns[random.nextInt(nouns.length)]}';
  }
}

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Post>> getFeed(String relationshipId) {
    return _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  Future<void> createPost(Post post, String relationshipId, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      final ref = _storage.ref().child('relationships/$relationshipId/posts/${post.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }
    final postWithUrl = Post(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorAvatar: post.authorAvatar,
      imageUrl: imageUrl ?? post.imageUrl,
      videoUrl: post.videoUrl,
      caption: post.caption,
      location: post.location,
      latitude: post.latitude,
      longitude: post.longitude,
      isEphemeral: post.isEphemeral,
      durationSeconds: post.durationSeconds,
      createdAt: post.createdAt,
      expiresAt: post.expiresAt,
    );
    await _firestore.collection('relationships').doc(relationshipId).collection('posts').doc(post.id).set(postWithUrl.toFirestore());
  }

  Future<void> toggleReaction(String relationshipId, String postId, String userId, String emoji) async {
    final postRef = _firestore.collection('relationships').doc(relationshipId).collection('posts').doc(postId);
    final doc = await postRef.get();
    if (!doc.exists) return;
    final reactions = Map<String, String>.from(doc.data()?['reactions'] ?? {});
    if (reactions[userId] == emoji) {
      reactions.remove(userId);
    } else {
      reactions[userId] = emoji;
    }
    await postRef.update({'reactions': reactions});
  }

  Future<void> addComment(String relationshipId, String postId, Comment comment) async {
    final postRef = _firestore.collection('relationships').doc(relationshipId).collection('posts').doc(postId);
    await postRef.update({
      'comments': FieldValue.arrayUnion([comment.toJson()]),
    });
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<ChatMessage>> getMessages(String relationshipId) {
    return _firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(ChatMessage message, String relationshipId, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      final ref = _storage.ref().child('relationships/$relationshipId/messages/${message.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }
    final msg = ChatMessage(
      id: message.id,
      senderId: message.senderId,
      text: message.text,
      imageUrl: imageUrl,
      type: message.type,
      timestamp: message.timestamp,
    );
    await _firestore.collection('relationships').doc(relationshipId).collection('messages').doc(message.id).set(msg.toFirestore());
  }

  Future<void> markAsRead(String relationshipId, String messageId) async {
    await _firestore.collection('relationships').doc(relationshipId).collection('messages').doc(messageId).update({'isRead': true});
  }
}

class PresenceService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String? _relationshipId;
  String? _userId;

  void initialize(String relationshipId, String userId) {
    _relationshipId = relationshipId;
    _userId = userId;
  }

  Future<void> setOnline({bool liveWindow = false}) async {
    if (_relationshipId == null || _userId == null) return;
    final ref = _database.ref().child('presence').child(_relationshipId!).child(_userId!);
    await ref.set({'status': 'online', 'liveWindow': liveWindow, 'lastSeen': ServerValue.timestamp});
    ref.onDisconnect().set({'status': 'offline', 'liveWindow': false, 'lastSeen': ServerValue.timestamp});
  }

  Future<void> setOffline() async {
    if (_relationshipId == null || _userId == null) return;
    await _database.ref().child('presence').child(_relationshipId!).child(_userId!).set({'status': 'offline', 'liveWindow': false, 'lastSeen': ServerValue.timestamp});
  }

  Stream<Map<String, dynamic>> listenToPartner(String partnerId) {
    return _database.ref().child('presence').child(_relationshipId!).child(partnerId).onValue.map((event) {
      if (event.snapshot.value == null) return {'status': 'offline', 'liveWindow': false};
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  Future<void> setLiveWindow(bool enabled) async {
    await _database.ref().child('presence').child(_relationshipId!).child(_userId!).update({'liveWindow': enabled});
  }
}

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final String relationshipId;
  final String userId;
  final DatabaseReference _dbRef;
  Function(MediaStream)? onRemoteStream;
  Function()? onDisconnected;
  Function(String)? onError;

  WebRTCService({required this.relationshipId, required this.userId, required this._dbRef});

  Future<void> initializeCamera() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': {'facingMode': 'user', 'width': {'ideal': 320}, 'height': {'ideal': 240}, 'frameRate': {'ideal': 15}},
      'audio': false,
    });
  }

  Future<void> createOffer() async {
    if (_localStream == null) await initializeCamera();
    _peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    });
    _peerConnection!.addStream(_localStream!);
    _peerConnection!.onAddStream = (stream) {
      _remoteStream = stream;
      onRemoteStream?.call(stream);
    };
    _peerConnection!.onIceCandidate = (candidate) {
      _sendSignal({'type': 'candidate', 'candidate': {'candidate': candidate.candidate, 'sdpMid': candidate.sdpMid, 'sdpMLineIndex': candidate.sdpMLineIndex}});
    };
    _peerConnection!.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed || state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        onDisconnected?.call();
      }
    };
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _sendSignal({'type': 'offer', 'sdp': offer.sdp});
  }

  Future<void> handleOffer(String sdp) async {
    if (_localStream == null) await initializeCamera();
    _peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    });
    _peerConnection!.addStream(_localStream!);
    _peerConnection!.onAddStream = (stream) {
      _remoteStream = stream;
      onRemoteStream?.call(stream);
    };
    _peerConnection!.onIceCandidate = (candidate) {
      _sendSignal({'type': 'candidate', 'candidate': {'candidate': candidate.candidate, 'sdpMid': candidate.sdpMid, 'sdpMLineIndex': candidate.sdpMLineIndex}});
    };
    await _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _sendSignal({'type': 'answer', 'sdp': answer.sdp});
  }

  Future<void> handleAnswer(String sdp) async {
    await _peerConnection?.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
  }

  Future<void> handleCandidate(Map<String, dynamic> candidate) async {
    await _peerConnection?.addCandidate(RTCIceCandidate(candidate['candidate'], candidate['sdpMid'], candidate['sdpMLineIndex']));
  }

  void toggleAudio(bool enabled) {
    _localStream?.getAudioTracks().forEach((track) => track.enabled = enabled);
  }

  void _sendSignal(Map<String, dynamic> signal) {
    _dbRef.child('signaling').child(relationshipId).child(userId).set({...signal, 'timestamp': ServerValue.timestamp});
  }

  void listenForSignals(String partnerId) {
    _dbRef.child('signaling').child(relationshipId).child(partnerId).onValue.listen((event) async {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      switch (data['type']) {
        case 'offer': await handleOffer(data['sdp']); break;
        case 'answer': await handleAnswer(data['sdp']); break;
        case 'candidate': await handleCandidate(data['candidate']); break;
      }
    });
  }

  Future<void> dispose() async {
    _localStream?.dispose();
    _remoteStream?.dispose();
    await _peerConnection?.close();
    _peerConnection = null;
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)));
    _ctrl.forward();
    Timer(const Duration(seconds: 2), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Transform.scale(scale: _scale.value, child: Opacity(opacity: _fade.value, child: child)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 30)],
                ),
                child: const Center(child: Text('U', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(height: 24),
              const Text('Us', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Your private space for two', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  Future<void> _login() async {
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20)],
                      ),
                      child: const Center(child: Text('U', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800))),
                    ),
                    const SizedBox(height: 20),
                    Text('Us', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Your private space for two', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 48),
                    _buildInput(_emailCtrl, 'Email or username', Icons.person_outline, TextInputAction.next),
                    const SizedBox(height: 14),
                    _buildInput(_passCtrl, 'Password', Icons.lock_outline, TextInputAction.done, obscure: _obscure, suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.textSecondary),
                      onPressed: () { HapticFeedback.lightImpact(); setState(() => _obscure = !_obscure); },
                    ), onSubmitted: (_) => _login()),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot password?', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500)))),
                    const SizedBox(height: 20),
                    SizedBox(height: 56, width: double.infinity, child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)) : const Text('Log In'),
                    )),
                    const SizedBox(height: 28),
                    Row(children: [Expanded(child: Container(height: 1, color: AppTheme.textSecondary.withOpacity(0.1))), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.4)))), Expanded(child: Container(height: 1, color: AppTheme.textSecondary.withOpacity(0.1)))]),
                    const SizedBox(height: 28),
                    _socialBtn(Icons.apple, 'Continue with Apple'),
                    const SizedBox(height: 10),
                    _socialBtn(Icons.g_mobiledata, 'Continue with Google', outlined: true),
                    const SizedBox(height: 10),
                    _socialBtn(Icons.phone_iphone, 'Use phone number', outlined: true),
                    const SizedBox(height: 28),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account? ", style: Theme.of(context).textTheme.bodyMedium),
                      GestureDetector(onTap: () => HapticFeedback.lightImpact(), child: const Text('Sign Up', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 16))),
                    ]),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, IconData icon, TextInputAction action, {bool obscure = false, Widget? suffix, Function(String)? onSubmitted}) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).inputDecorationTheme.fillColor, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: ctrl, obscureText: obscure, textInputAction: action, onSubmitted: onSubmitted,
        style: Theme.of(context).textTheme.bodyLarge, cursorColor: AppTheme.primary,
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary.withOpacity(0.5)), suffixIcon: suffix,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
        ),
      ),
    );
  }

  Widget _socialBtn(IconData icon, String label, {bool outlined = false}) {
    return GestureDetector(
      onTap: () => HapticFeedback.mediumImpact(),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: outlined ? Border.all(color: AppTheme.textSecondary.withOpacity(0.2), width: 1.5) : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose();
    super.dispose();
  }
}

// ============================================================
// MAIN SCREEN (Bottom Navigation)
// ============================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final _pages = const [FeedScreen(), ChatScreen(), SizedBox(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(top: BorderSide(color: AppTheme.textSecondary.withOpacity(0.05))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _navItem(Icons.home_outlined, Icons.home_filled, 0),
              _navItem(Icons.chat_bubble_outline, Icons.chat_bubble, 1),
              _cameraBtn(),
              _navItem(Icons.person_outline, Icons.person, 3),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData outlined, IconData filled, int index) {
    final selected = _index == index;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); setState(() => _index = index); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        child: Icon(selected ? filled : outlined, size: 28, color: selected ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.4)),
      ),
    );
  }

  Widget _cameraBtn() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScreen()));
      },
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 12)],
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
      ),
    );
  }
}

// ============================================================
// FEED SCREEN
// ============================================================
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _feedService = FeedService();
  final _presenceService = PresenceService();
  final _dbRef = FirebaseDatabase.instance.ref();
  WebRTCService? _webrtc;
  RTCVideoRenderer? _remoteRenderer;
  bool _partnerOnline = false;
  bool _liveWindow = false;
  StreamSubscription? _presenceSub;
  final List<Post> _posts = [];
  StreamSubscription? _feedSub;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    _feedSub = _feedService.getFeed('test_relationship').listen((posts) {
      if (mounted) setState(() => _posts.clear()..addAll(posts));
    });
    _presenceService.initialize('test_relationship', 'user_a');
    await _presenceService.setOnline();
    _presenceSub = _presenceService.listenToPartner('user_b').listen((presence) {
      final wasLive = _liveWindow;
      setState(() {
        _partnerOnline = presence['status'] == 'online';
        _liveWindow = presence['liveWindow'] == true;
      });
      if (!wasLive && _liveWindow) _startLiveWindow();
      else if (wasLive && !_liveWindow) _stopLiveWindow();
    });
  }

  Future<void> _startLiveWindow() async {
    _webrtc = WebRTCService(relationshipId: 'test_relationship', userId: 'user_a', dbRef: _dbRef);
    _webrtc!.onRemoteStream = (stream) {
      setState(() {
        _remoteRenderer = RTCVideoRenderer();
        _remoteRenderer!.srcObject = stream;
        _remoteRenderer!.initialize();
      });
    };
    _webrtc!.onDisconnected = _stopLiveWindow;
    _webrtc!.listenForSignals('user_b');
    await _webrtc!.createOffer();
  }

  void _stopLiveWindow() {
    _webrtc?.dispose();
    _remoteRenderer?.dispose();
    setState(() { _remoteRenderer = null; _webrtc = null; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Us'),
        actions: [
          if (_partnerOnline)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () { _presenceService.setLiveWindow(!_liveWindow); setState(() => _liveWindow = !_liveWindow); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _liveWindow ? AppTheme.primary : AppTheme.success, borderRadius: BorderRadius.circular(12)),
                  child: Text(_liveWindow ? 'LIVE' : 'Online', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          _posts.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.photo_library_outlined, size: 64, color: AppTheme.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Your shared moments will appear here', style: Theme.of(context).textTheme.bodyMedium),
                ]))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) => _PostCard(post: _posts[index]),
                ),
          if (_remoteRenderer != null && _liveWindow)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8, right: 16,
              child: GestureDetector(
                onTap: () {
                  _webrtc?.toggleAudio(true);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
                    backgroundColor: Colors.black,
                    body: Stack(children: [
                      Center(child: RTCVideoView(_remoteRenderer!)),
                      SafeArea(child: Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () { _webrtc?.toggleAudio(false); Navigator.pop(context); }))),
                    ]),
                  )));
                },
                child: Container(
                  width: 100, height: 140,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.primary, width: 2)),
                  child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Stack(children: [
                    RTCVideoView(_remoteRenderer!, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                    Positioned(bottom: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(4)), child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8)))),
                  ])),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _feedSub?.cancel();
    _presenceSub?.cancel();
    _presenceService.setOffline();
    _stopLiveWindow();
    super.dispose();
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Theme.of(context).colorScheme.surface,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark])), child: Center(child: Text(post.authorName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 8),
            Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const Spacer(),
            if (post.isEphemeral) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('24h', style: TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w600))),
          ]),
        ),
        if (post.imageUrl != null) CachedNetworkImage(imageUrl: post.imageUrl!, width: double.infinity, fit: BoxFit.cover, placeholder: (_, __) => Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(height: 300, color: Colors.grey[300])), errorWidget: (_, __, ___) => Container(height: 300, color: Colors.grey[200], child: const Icon(Icons.broken_image))) else Container(height: 200, color: AppTheme.primary.withOpacity(0.05), child: Center(child: Text(post.caption ?? '', style: const TextStyle(fontSize: 16)))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            GestureDetector(onTap: () {}, child: const Icon(Icons.favorite_border, size: 24, color: AppTheme.textPrimary)),
            const SizedBox(width: 16),
            GestureDetector(onTap: () {}, child: const Icon(Icons.chat_bubble_outline, size: 22, color: AppTheme.textPrimary)),
            const Spacer(),
            GestureDetector(onTap: () {}, child: const Icon(Icons.bookmark_border, size: 22, color: AppTheme.textPrimary)),
          ]),
        ),
        if (post.caption != null && post.caption!.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(post.caption!, style: const TextStyle(fontSize: 14))),
        if (post.location != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: Text('📍 ${post.location!}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text(_formatTime(post.createdAt), style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
      ]),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}

// ============================================================
// CHAT SCREEN
// ============================================================
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<ChatMessage> _messages = [];
  StreamSubscription? _msgSub;

  @override
  void initState() {
    super.initState();
    _msgSub = _chatService.getMessages('test_relationship').listen((msgs) {
      if (mounted) {
        setState(() => _messages.clear()..addAll(msgs.reversed));
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    });
  }

  Future<void> _sendMessage() async {
    if (_msgCtrl.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    final msg = ChatMessage(id: const Uuid().v4(), senderId: 'user_a', text: _msgCtrl.text.trim(), type: MessageType.text, timestamp: DateTime.now());
    await _chatService.sendMessage(msg, 'test_relationship', null);
    _msgCtrl.clear();
  }

  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final msg = ChatMessage(id: const Uuid().v4(), senderId: 'user_a', type: MessageType.image, timestamp: DateTime.now(), imageUrl: picked.path);
    await _chatService.sendMessage(msg, 'test_relationship', File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark])), child: const Center(child: Text('P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))),
          const SizedBox(width: 10),
          const Text('Partner', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined), onPressed: () {}),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl, reverse: true, physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isMe = msg.senderId == 'user_a';
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primary : (Theme.of(context).brightness == Brightness.dark ? AppTheme.darkCard : Colors.white),
                    borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(isMe ? 18 : 4), bottomRight: Radius.circular(isMe ? 4 : 18)),
                  ),
                  child: msg.type == MessageType.text
                      ? Text(msg.text ?? '', style: TextStyle(color: isMe ? Colors.white : null, fontSize: 16))
                      : (msg.imageUrl != null ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(msg.imageUrl!), width: 150, fit: BoxFit.cover)) : const SizedBox()),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border(top: BorderSide(color: AppTheme.textSecondary.withOpacity(0.1)))),
          child: Row(children: [
            IconButton(icon: const Icon(Icons.image_outlined, color: AppTheme.primary), onPressed: _sendImage),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkCard : const Color(0xFFF2F2F7), borderRadius: BorderRadius.circular(24)),
                child: TextField(
                  controller: _msgCtrl, style: Theme.of(context).textTheme.bodyLarge, cursorColor: AppTheme.primary,
                  decoration: const InputDecoration(hintText: 'Message...', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10)),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.send, color: AppTheme.primary), onPressed: _sendMessage),
          ]),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _msgSub?.cancel(); _msgCtrl.dispose(); _scrollCtrl.dispose();
    super.dispose();
  }
}

// ============================================================
// CAMERA SCREEN
// ============================================================
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRear = false;
  bool _flash = false;
  final _feedService = FeedService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras![_isRear ? 1 : 0], ResolutionPreset.high);
    await _controller?.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    _isRear = !_isRear;
    await _controller?.dispose();
    _controller = CameraController(_cameras![_isRear ? 1 : 0], ResolutionPreset.high);
    await _controller?.initialize();
    setState(() {});
  }

  Future<void> _capture() async {
    HapticFeedback.mediumImpact();
    try {
      final image = await _controller!.takePicture();
      final post = Post(id: const Uuid().v4(), authorId: 'user_a', authorName: 'You', createdAt: DateTime.now());
      await _feedService.createPost(post, 'test_relationship', File(image.path));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted!'), behavior: SnackBarBehavior.floating));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), behavior: SnackBarBehavior.floating));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  Row(children: [
                    IconButton(icon: Icon(_flash ? Icons.flash_on : Icons.flash_off, color: Colors.white), onPressed: () { setState(() => _flash = !_flash); }),
                    IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: _switchCamera),
                  ]),
                ]),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: _capture,
                  child: Container(width: 72, height: 72, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4))),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) _controller?.dispose();
    else if (state == AppLifecycleState.resumed) _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
}

// ============================================================
// PROFILE SCREEN
// ============================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(height: 30),
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20)]),
            child: const Center(child: Text('Y', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700))),
          ),
          const SizedBox(height: 16),
          const Text('Your Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('@yourusername', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(width: double.infinity, height: 44, child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: AppTheme.textSecondary.withOpacity(0.2))),
              child: Text('Edit Profile', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
            )),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('342', 'Posts'),
              Container(width: 1, height: 40, color: AppTheme.textSecondary.withOpacity(0.1)),
              _stat('487', 'Days'),
              Container(width: 1, height: 40, color: AppTheme.textSecondary.withOpacity(0.1)),
              _stat('1.2k', 'Photos'),
            ]),
          ),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _tab('📸 Posts', true),
            const SizedBox(width: 24),
            _tab('❤️ Likes', false),
          ]),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
            itemCount: 9,
            itemBuilder: (context, index) => Container(color: AppTheme.primary.withOpacity(0.1 + (index * 0.05)), child: Center(child: Icon(Icons.image, color: AppTheme.primary.withOpacity(0.3), size: 32))),
          ),
        ]),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.primary)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
    ]);
  }

  Widget _tab(String label, bool active) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: active ? AppTheme.primary : AppTheme.textSecondary)),
        if (active) const SizedBox(height: 4, child: SizedBox(width: 30, child: Divider(color: AppTheme.primary, thickness: 2))),
      ]),
    );
  }
}
