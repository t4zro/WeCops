import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: UsApp()));
}

class UsApp extends StatelessWidget {
  const UsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Us',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF6B6B),
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1C1C1E),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF477E)]),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(child: Text('U', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(height: 24),
              const Text('Us', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Your private space for two', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  Future<void> _login() async {
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailCtrl.text.trim(), password: _passCtrl.text);
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), behavior: SnackBarBehavior.floating));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _signup() async {
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    try {
      await   @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final _pages = const [FeedScreen(), ChatScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF2F2F7)))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _navItem(Icons.home_outlined, Icons.home_filled, 0),
              _navItem(Icons.chat_bubble_outline, Icons.chat_bubble, 1),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.camera);
                  if (picked != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo taken!')));
                  }
                },
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF477E)]), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                ),
              ),
              _navItem(Icons.person_outline, Icons.person, 2),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData outlined, IconData filled, int index) {
    final selected = _index == index;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); setState(() => _index = index); },
      child: Icon(selected ? filled : outlined, size: 28, color: selected ? const Color(0xFFFF6B6B) : const Color(0xFF8E8E93)),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Us')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.photo_library_outlined, size: 64, color: const Color(0xFFFF6B6B).withOpacity(0.3)),
          const Text('Your shared moments will appear here', style: TextStyle(color: Color(0xFF8E8E93))),
        ]),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots().listen((snapshot) {
      setState(() {
        _messages.clear();
        for (var doc in snapshot.docs) _messages.add(doc.data());
      });
    });
  }

  Future<void> _send() async {
    if (_msgCtrl.text.trim().isEmpty) return;
    await _firestore.collection('messages').add({
      'text': _msgCtrl.text.trim(),
      'sender': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      'timestamp': FieldValue.serverTimestamp(),
    });
    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            reverse: true, padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (_, i) {
              final msg = _messages[i];
              final isMe = msg['sender'] == FirebaseAuth.instance.currentUser?.uid;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFFFF6B6B) : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(msg['text'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFF2F2F7), borderRadius: BorderRadius.circular(24)),
                child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Message...', border: InputBorder.none)),
              ),
            ),
            IconButton(icon: const Icon(Icons.send, color: Color(0xFFFF6B6B)), onPressed: _send),
          ]),
        ),
      ]),
    );
  }

  @override
  void dispose() { _sub?.cancel(); _msgCtrl.dispose(); super.dispose(); }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 90, height: 90,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF477E)])),
            child: Center(child: Text(user?.email?.substring(0,1).toUpperCase() ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 36))),
          ),
          const SizedBox(height: 16),
          Text(user?.email ?? '', style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF3B30), side: const BorderSide(color: Color(0xFFFF3B30))),
            child: const Text('Sign Out'),
          ),
        ]),
      ),
    );
  }
}
