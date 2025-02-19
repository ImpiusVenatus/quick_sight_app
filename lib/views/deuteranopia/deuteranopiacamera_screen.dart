import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DeuteranopiaView extends StatefulWidget {
  final bool multiple;

  const DeuteranopiaView({
    super.key,
    this.multiple = false,
  });

  @override
  DeuteranopiaViewState createState() => DeuteranopiaViewState();
}

class DeuteranopiaViewState extends State<DeuteranopiaView> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  Timer? _recordingTimer;
  String? recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final firstCamera = cameras.first;

      _controller = CameraController(firstCamera, ResolutionPreset.max,
          enableAudio: false);

      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((e) {
        debugPrint("Error initializing camera: $e");
      });
    } else {
      debugPrint("No cameras available");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: _buildAppBar(),
          body: _buildBody(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      forceMaterialTransparency: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller != null) {
          return _buildCameraPreview(context);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Camera initialization failed: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  1,
                  1.3,
                  0,
                  0,
                  0,
                  0,
                  1.3,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: CameraPreview(_controller!),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
