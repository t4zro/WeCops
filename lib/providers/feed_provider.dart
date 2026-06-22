import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/feed_service.dart';

final feedServiceProvider = Provider((ref) {
  return FeedService();
});
