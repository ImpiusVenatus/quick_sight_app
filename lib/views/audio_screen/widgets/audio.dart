import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

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

  bool _isPlaying = false;
  String? audioPath;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        (duration.inMilliseconds.remainder(1000) ~/ 10)
            .toString()
            .padLeft(2, '0');
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  Widget _buildPlayingWidget() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 5,
          child: Text(
            _currentPosition.inMilliseconds == 0
                ? _formatDuration(_totalDuration)
                : _formatDuration(_currentPosition),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'RobotoMono',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: _togglePlayback,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(22, 22, 22, 1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  _audioPlayer.playing ? Icons.graphic_eq : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12.0,
                      ),
                      trackHeight: 2.0,
                    ),
                    child: Slider(
                      value: _currentPosition.inMilliseconds.toDouble(),
                      min: 0,
                      max: _totalDuration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        _seekTo(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(
          color: const Color.fromRGBO(60, 66, 71, 0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: _buildPlayingWidget(),
    );
  }
}
