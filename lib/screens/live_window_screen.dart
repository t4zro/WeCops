import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LiveWindowScreen extends StatefulWidget {
  const LiveWindowScreen({super.key});

  @override
  State<LiveWindowScreen> createState() => _LiveWindowScreenState();
}

class _LiveWindowScreenState extends State<LiveWindowScreen> {
  final RTCVideoRenderer local = RTCVideoRenderer();
  final RTCVideoRenderer remote = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  Future<void> initRenderers() async {
    await local.initialize();
    await remote.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Live Window"),
        backgroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          Center(
            child: RTCVideoView(remote),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 120,
              height: 160,
              child: RTCVideoView(local, mirror: true),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    local.dispose();
    remote.dispose();
    super.dispose();
  }
}
