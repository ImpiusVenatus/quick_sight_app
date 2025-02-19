import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await _checkToken();
    } catch (e) {
      return debugPrint("Error splash: $e");
    }
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    Widget child;
    child = Image(
      image: const AssetImage('assets/logo/logo-text.png'),
      height: MediaQuery.of(context).size.width * 0.35,
    );
    return Scaffold(
      backgroundColor:
          isDarkTheme ? Colors.black : const Color.fromRGBO(255, 255, 255, 1),
      body: Center(child: child),
    );
  }
}
