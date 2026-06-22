import 'dart:io';
import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              child: Text(post.authorName[0].toUpperCase()),
            ),
            title: Text(post.authorName),
            subtitle: Text(post.location ?? ''),
          ),

          // Image / Media
          if (post.imageUrl != null)
            Image.network(post.imageUrl!, fit: BoxFit.cover)
          else if (post.videoUrl != null)
            const Icon(Icons.play_circle, size: 120)
          else
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(post.caption ?? ''),
            ),

          // Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: onComment,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.caption ?? ''),
          ),
        ],
      ),
    );
  }
}
