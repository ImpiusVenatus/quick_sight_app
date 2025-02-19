import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultView extends StatefulWidget {
  final String description;
  final File imageFile;

  const ResultView(
      {super.key, required this.description, required this.imageFile});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final FlutterTts _flutterTts = FlutterTts();
  int _tapCount = 0;
  bool _isWaitingForSecondTap = false;

  @override
  void initState() {
    super.initState();
    _speakDescription();
  }

  Future<void> _speakDescription() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(widget.description);
  }

  void _handleTap() {
    if (_isWaitingForSecondTap) {
      Navigator.pop(context);
      return;
    }

    _isWaitingForSecondTap = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isWaitingForSecondTap) {
        _speakDescription();
      }
      _isWaitingForSecondTap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
