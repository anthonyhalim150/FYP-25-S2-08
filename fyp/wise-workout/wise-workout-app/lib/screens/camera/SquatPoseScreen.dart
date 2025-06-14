import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wise_workout_app/utils/image_convert.dart';

class SquatPoseScreen extends StatefulWidget {
  const SquatPoseScreen({super.key});

  @override
  State<SquatPoseScreen> createState() => _SquatPoseScreenState();
}

class _SquatPoseScreenState extends State<SquatPoseScreen> {
  List<CameraDescription> cameras = [];
  CameraController? _controller;
  WebSocketChannel? channel;
  int correct = 0;
  int incorrect = 0;
  bool isSending = false;
  bool isCameraReady = false;
  bool isWebSocketOpen = false;
  int currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      await initializeController(cameras[currentCameraIndex]);
    } catch (e) {
      print("Camera initialization failed: $e");
    }
  }

  Future<void> initializeController(CameraDescription camera) async {
    try {
      _controller?.dispose();
      _controller = CameraController(camera, ResolutionPreset.low);
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          isCameraReady = true;
        });
      }

      channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080/ws/squats'));
      isWebSocketOpen = true;

      channel!.stream.listen((message) {
        final data = jsonDecode(message);
        if (mounted) {
          setState(() {
            correct = data['correct'] ?? 0;
            incorrect = data['incorrect'] ?? 0;
          });
        }
      }, onDone: () {
        if (mounted) {
          setState(() {
            isWebSocketOpen = false;
          });
        } else {
          isWebSocketOpen = false;
        }
        print('WebSocket closed');
      }, onError: (error) {
        if (mounted) {
          setState(() {
            isWebSocketOpen = false;
          });
        } else {
          isWebSocketOpen = false;
        }
        print('WebSocket error: $error');
      });

      _controller!.startImageStream((CameraImage image) async {
        if (!isWebSocketOpen || isSending) return;
        isSending = true;
        try {
          final jpegBytes = convertCameraImageToJpeg(image);
          final base64Image = base64Encode(jpegBytes);
          channel!.sink.add(base64Image);
        } catch (e) {
          print("Frame conversion error: $e");
        } finally {
          await Future.delayed(const Duration(milliseconds: 500));
          isSending = false;
        }
      });
    } catch (e) {
      print("Controller error: $e");
    }
  }

  void switchCamera() async {
    if (cameras.isEmpty) return;
    currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
    await initializeController(cameras[currentCameraIndex]);
  }

  @override
  void dispose() {
    try {
      _controller?.dispose();
      if (isWebSocketOpen) {
        channel?.sink.close();
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Squat Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Correct: $correct'),
            Text('Incorrect: $incorrect'),
            const SizedBox(height: 20),
            if (_controller != null && _controller!.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
