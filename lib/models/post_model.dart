import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart';

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
  final DateTime createdAt;
  final DateTime? expiresAt;

  final Map<String, String> reactions;
  final List<Comment> comments;

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
    required this.createdAt,
    this.expiresAt,
    this.reactions = const {},
    this.comments = const [],
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
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      isEphemeral: data['isEphemeral'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      reactions: Map<String, String>.from(data['reactions'] ?? {}),
      comments: (data['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
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
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt':
          expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'reactions': reactions,
      'comments': comments.map((e) => e.toMap()).toList(),
    };
  }
}
