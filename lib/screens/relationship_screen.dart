import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/relationship_provider.dart';

class RelationshipScreen extends ConsumerStatefulWidget {
  const RelationshipScreen({super.key});

  @override
  ConsumerState<RelationshipScreen> createState() =>
      _RelationshipScreenState();
}

class _RelationshipScreenState extends ConsumerState<RelationshipScreen> {
  final codeCtrl = TextEditingController();
  String? myCode;
  bool loading = false;

  Future<void> create() async {
    setState(() => loading = true);

    final service = ref.read(relationshipServiceProvider);
    myCode = await service.createRelationship();

    setState(() => loading = false);
  }

  Future<void> join() async {
    setState(() => loading = true);

    try {
      final service = ref.read(relationshipServiceProvider);
      await service.joinRelationship(codeCtrl.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relationship Setup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Create or Join your private 2-person space",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : create,
              child: const Text("Create Relationship"),
            ),

            if (myCode != null) ...[
              const SizedBox(height: 20),
              Text("Your Code: $myCode"),
            ],

            const SizedBox(height: 30),

            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(
                hintText: "Enter partner code",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loading ? null : join,
              child: const Text("Join Relationship"),
            ),
          ],
        ),
      ),
    );
  }
}
