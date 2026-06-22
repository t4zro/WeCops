import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/feed_service.dart';

final feedServiceProvider = Provider<FeedService>((ref) {
  return FeedService();
});

final feedProvider =
    StreamProvider.family<List<Post>, String>((ref, relationshipId) {
  return ref.watch(feedServiceProvider).getFeed(relationshipId);
});
