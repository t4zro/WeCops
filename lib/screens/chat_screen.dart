import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: ListView(
        children: const [
          ListTile(title: Text("Friend 1"), subtitle: Text("Hey!")),
          ListTile(title: Text("Friend 2"), subtitle: Text("Hello")),
        ],
      ),
    );
  }
}
