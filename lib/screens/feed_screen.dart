import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../providers/relationship_provider.dart';
import '../models/post_model.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relService = ref.watch(relationshipServiceProvider);

    return StreamBuilder(
      stream: relService.myRelationship(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final relationshipId = snapshot.data!.id;
        final feedService = ref.watch(feedServiceProvider);

        return Scaffold(
          appBar: AppBar(title: const Text("Private Feed")),
          body: StreamBuilder<List<PostModel>>(
            stream: feedService.getFeed(relationshipId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final posts = snap.data!;

              if (posts.isEmpty) {
                return const Center(
                  child: Text("No posts yet"),
                );
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(post.imageUrl),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(post.caption),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
