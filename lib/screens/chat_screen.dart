import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import '../providers/relationship_provider.dart';
import '../models/message_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final relService = ref.watch(relationshipServiceProvider);
    final chatService = ref.watch(chatServiceProvider);

    return StreamBuilder(
      stream: relService.myRelationship(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final relationshipId = snapshot.data!.id;

        return Scaffold(
          appBar: AppBar(title: const Text("Private Chat")),
          body: Column(
            children: [
              // ================= MESSAGES =================
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: chatService.getMessages(relationshipId),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snap.data!;

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final msg = messages[i];
                        final isMe = msg.senderId ==
                            relService._auth.currentUser!.uid;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // ================= INPUT =================
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        decoration: const InputDecoration(
                          hintText: "Message...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (textCtrl.text.trim().isEmpty) return;

                        await chatService.sendMessage(
                          relationshipId: relationshipId,
                          text: textCtrl.text.trim(),
                        );

                        textCtrl.clear();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
