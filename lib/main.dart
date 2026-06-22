import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: UsApp()));
}

class UsApp extends ConsumerWidget {
  const UsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "US App",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          } else {
            return const HomeScreen();
          }
        },
        loading: () => const SplashScreen(),
        error: (e, _) => Scaffold(
          body: Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
