import 'package:flutter/material.dart';
import 'package:test_3d/screens/characters_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🕒 تأخير بسيط لتجنب Crash من WebView أثناء الإقلاع
  await Future.delayed(const Duration(milliseconds: 100));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeStartScreen(),
    );
  }
}

/// 🧩 شاشة وسيطة آمنة لتفادي freeze عند التشغيل
class SafeStartScreen extends StatefulWidget {
  const SafeStartScreen({super.key});

  @override
  State<SafeStartScreen> createState() => _SafeStartScreenState();
}

class _SafeStartScreenState extends State<SafeStartScreen> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
        ),
      );
    }

    return const CharacterSelectionScreen();
  }
}
