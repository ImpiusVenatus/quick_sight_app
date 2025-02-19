import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class AudioSymbolView extends StatelessWidget {
  final String? audioPath;

  const AudioSymbolView({super.key, this.audioPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: audioPath == null
                  ? const Icon(
                      Icons.audiotrack,
                      size: 100.0,
                      color: Colors.white,
                    )
                  : AudioPlayback(initialRecordedAudioPath: audioPath),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: const Text(
                  'Tap here to go to the home screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayback extends StatefulWidget {
  final String? initialRecordedAudioPath;

  const AudioPlayback({super.key, this.initialRecordedAudioPath});

  @override
  State<AudioPlayback> createState() => AudioPlaybackState();
}

class AudioPlaybackState extends State<AudioPlayback> {
  final ja.AudioPlayer _audioPlayer = ja.AudioPlayer();
  StreamSubscription<ja.PlayerState?>? _playerStateChangedSubscription;
  StreamSubscription<Duration?>? _positionChangedSubscription;
  StreamSubscription<Duration?>? _durationChangedSubscription;

  bool _isPlaying = true;
  String? audioPath;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    _audioPlayer.play();
  }

  @override
  void didUpdateWidget(AudioPlayback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRecordedAudioPath != widget.initialRecordedAudioPath) {
      _setupAudioPlayer();
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription?.cancel();
    _positionChangedSubscription?.cancel();
    _durationChangedSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<File> downloadFile(String url, String filename) async {
    Directory tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$filename';
    final file = File(filePath);

    return file;
  }

  Future<void> _setupAudioPlayer() async {
    audioPath = widget.initialRecordedAudioPath;
    if (audioPath != null) {
      try {
        if (audioPath!.startsWith('/')) {
          await _audioPlayer.setFilePath(audioPath!);
        } else {
          final file = await downloadFile(audioPath!, 'lifestory.m4a');
          await _audioPlayer.setFilePath(file.path);
        }
      } catch (e) {
        debugPrint("Error setting up audio player: $e");
      }

      _positionChangedSubscription =
          _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });

      _durationChangedSubscription =
          _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
        });
      });

      _playerStateChangedSubscription =
          _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ja.ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _currentPosition = Duration.zero;
          });
          _audioPlayer.pause();
          _audioPlayer.seek(_currentPosition);
        }
      });
    }
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _togglePlayback,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Expanded(
            child: Slider(
              value: _currentPosition.inMilliseconds.toDouble(),
              min: 0,
              max: _totalDuration.inMilliseconds.toDouble(),
              onChanged: (value) {
                _seekTo(Duration(milliseconds: value.toInt()));
              },
              activeColor: const Color.fromARGB(255, 255, 255, 255),
              inactiveColor:
                  const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
