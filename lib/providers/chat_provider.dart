import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

final chatProvider =
    StreamProvider.family<List<ChatMessage>, String>((ref, relationshipId) {
  return ref.watch(chatServiceProvider).getMessages(relationshipId);
});
