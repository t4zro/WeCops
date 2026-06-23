import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Posts"),
              Tab(text: "Followers"),
              Tab(text: "Settings"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _Posts(),
            _Followers(),
            _ProfileSettings(),
          ],
        ),
      ),
    );
  }
}

class _Posts extends StatelessWidget {
  const _Posts();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("User Posts Grid"));
  }
}

class _Followers extends StatelessWidget {
  const _Followers();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text("Followers list")),
        ListTile(title: Text("Following list")),
        ListTile(title: Text("Best Friends")),
        ListTile(title: Text("In Relationship")),
      ],
    );
  }
}

class _ProfileSettings extends StatelessWidget {
  const _ProfileSettings();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text("Change Profile Photo")),
        ListTile(title: Text("Delete Profile")),
        ListTile(title: Text("Report Profile")),
        ListTile(title: Text("Private / Public Toggle")),
      ],
    );
  }
}
