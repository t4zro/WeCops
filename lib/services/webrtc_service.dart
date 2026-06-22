import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_database/firebase_database.dart';

class WebRTCService {
  RTCPeerConnection? _pc;
  MediaStream? _localStream;

  final String relationshipId;
  final String userId;
  final DatabaseReference db;

  WebRTCService({
    required this.relationshipId,
    required this.userId,
    required this.db,
  });

  /// INIT CAMERA
  Future<void> initCamera() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });
  }

  /// CREATE PEER
  Future<void> createOffer() async {
    await initCamera();

    _pc = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    _pc!.addStream(_localStream!);

    _pc!.onIceCandidate = (c) {
      db.child('signaling/$relationshipId/$userId').set({
        'candidate': c.toMap(),
      });
    };

    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);

    db.child('signaling/$relationshipId/$userId').set({
      'offer': offer.sdp,
    });
  }

  /// HANDLE OFFER
  Future<void> handleOffer(String sdp) async {
    await initCamera();

    _pc = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    _pc!.addStream(_localStream!);

    await _pc!.setRemoteDescription(
      RTCSessionDescription(sdp, 'offer'),
    );

    final answer = await _pc!.createAnswer();
    await _pc!.setLocalDescription(answer);

    db.child('signaling/$relationshipId/$userId').set({
      'answer': answer.sdp,
    });
  }

  void dispose() {
    _localStream?.dispose();
    _pc?.close();
  }
}
