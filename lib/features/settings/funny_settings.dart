import 'package:flutter/material.dart';

class FunnySettings extends StatelessWidget {
  const FunnySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setting 👉👈🌚")),
      body: ListView(
        children: const [
          ListTile(title: Text("Privacy 🔒")),
          ListTile(title: Text("Help 🆘")),
          ListTile(title: Text("Data Saver 📉")),
          ListTile(title: Text("Authorization 🔑")),
          ListTile(title: Text("2 Step Verification 🛡")),
          ListTile(title: Text("Channels 📢")),
          ListTile(title: Text("Login Sessions 📱")),
        ],
      ),
    );
  }
}
