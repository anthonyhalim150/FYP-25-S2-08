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
  List<String> feedbackMessages = [];
  Uint8List? processedImage;

  @override
  void initState() {
    super.initState();
    print('[INIT] Initializing camera...');
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      print('[CAMERA] Found ${cameras.length} cameras');
      await initializeController(cameras[currentCameraIndex]);
    } catch (e) {
      print('[ERROR] Failed to initialize camera: $e');
    }
  }

  Future<void> initializeController(CameraDescription camera) async {
    try {
      _controller?.dispose();
      _controller = CameraController(camera, ResolutionPreset.low);
      await _controller!.initialize();
      print('[CAMERA] Controller initialized');

      if (mounted) {
        setState(() => isCameraReady = true);
      }

      print('[WEBSOCKET] Connecting to backend...');
      channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080/ws/squats'));
      isWebSocketOpen = true;

      channel!.stream.listen((message) {
        print('[WEBSOCKET] Message received');
        final data = jsonDecode(message);
        if (mounted) {
          setState(() {
            correct = data['correct'] ?? 0;
            incorrect = data['incorrect'] ?? 0;
            feedbackMessages = List<String>.from(data['feedback'] ?? []);
            if (data['image'] != null) {
              processedImage = base64Decode(data['image']);
              print('[IMAGE] Processed frame received and decoded');
            }
          });
        }
      }, onDone: () {
        print('[WEBSOCKET] Connection closed');
        if (mounted) {
          setState(() => isWebSocketOpen = false);
        }
      }, onError: (error) {
        print('[WEBSOCKET] Error: $error');
        if (mounted) {
          setState(() => isWebSocketOpen = false);
        }
      });

      _controller!.startImageStream((CameraImage image) async {
        if (!isWebSocketOpen || isSending) return;
        isSending = true;
        try {
          final jpegBytes = convertCameraImageToJpeg(image);
          final base64Image = base64Encode(jpegBytes);
          print('[STREAM] Sending image frame to backend...');
          channel!.sink.add(base64Image);
        } catch (e) {
          print('[ERROR] Failed to send frame: $e');
        } finally {
          await Future.delayed(const Duration(milliseconds: 500));
          isSending = false;
        }
      });
    } catch (e) {
      print('[ERROR] Controller setup failed: $e');
    }
  }

  void switchCamera() async {
    if (cameras.isEmpty) return;
    currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
    print('[CAMERA] Switching to camera $currentCameraIndex');
    await initializeController(cameras[currentCameraIndex]);
  }

  @override
  void dispose() {
    try {
      _controller?.dispose();
      print('[DISPOSE] Camera controller disposed');
      if (isWebSocketOpen) {
        channel?.sink.close();
        print('[DISPOSE] WebSocket closed');
      }
    } catch (e) {
      print('[DISPOSE ERROR] $e');
    }
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
            Text('Correct ✅: $correct'),
            Text('Incorrect ❌: $incorrect'),
            const SizedBox(height: 16),
            if (feedbackMessages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: feedbackMessages.map((msg) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      msg,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            const SizedBox(height: 20),
            if (processedImage != null)
              Image.memory(processedImage!)
            else if (_controller != null && _controller!.value.isInitialized)
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
