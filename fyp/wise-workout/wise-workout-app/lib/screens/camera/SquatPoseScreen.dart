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
  String poseStatus = '';

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
      print('[ERROR] Camera init failed: $e');
    }
  }

  Future<void> initializeController(CameraDescription camera) async {
    try {
      _controller?.dispose();
      _controller = CameraController(camera, ResolutionPreset.medium);
      await _controller!.initialize();

      if (mounted) {
        setState(() => isCameraReady = true);
      }

      channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080/ws/squats'));
      isWebSocketOpen = true;

      channel!.stream.listen((message) {
        try {
          final data = jsonDecode(message);
          if (mounted) {
            setState(() {
              correct = data['correct'] ?? 0;
              incorrect = data['incorrect'] ?? 0;
              feedbackMessages = List<String>.from(data['feedback'] ?? []);
              poseStatus = data['status'] ?? '';
              if (data['image'] != null) {
                processedImage = base64Decode(data['image']);
              }
            });
          }
        } catch (e) {
          print('[WEBSOCKET ERROR] Failed to decode: $e');
        }
      }, onDone: () {
        if (mounted) setState(() => isWebSocketOpen = false);
      }, onError: (error) {
        if (mounted) setState(() => isWebSocketOpen = false);
      });

      _controller!.startImageStream((CameraImage image) async {
        if (!isWebSocketOpen || isSending) return;
        isSending = true;
        try {
          final jpegBytes = convertCameraImageToJpeg(image);
          final base64Image = base64Encode(jpegBytes);
          channel!.sink.add(base64Image);
        } catch (_) {} finally {
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
    await initializeController(cameras[currentCameraIndex]);
  }

  Widget _buildPoseStatusBanner(String status) {
    if (status == 'camera_misaligned') {
      return _statusBox("📐 Please align the camera to your side", Colors.orange);
    } else if (status == 'incorrect_pose') {
      return _statusBox("⚠️ Incorrect posture detected", Colors.red);
    } else if (status == 'inactive_reset') {
      return _statusBox("🕒 Inactivity detected. Counter reset", Colors.blueGrey);
    } else if (status == 'no_pose_detected') {
      return _statusBox("🙈 No pose detected in frame", Colors.grey);
    }
    return const SizedBox.shrink();
  }

  Widget _statusBox(String message, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      color: bgColor,
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
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
      body: Column(
        children: [
          if (poseStatus.isNotEmpty) _buildPoseStatusBanner(poseStatus),
          if (feedbackMessages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: feedbackMessages.map((msg) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    msg,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )).toList(),
              ),
            ),
          Expanded(
            child: Center(
              child: processedImage != null
                ? Image.memory(processedImage!, width: double.infinity, fit: BoxFit.contain)
                : (_controller != null && _controller!.value.isInitialized)
                  ? CameraPreview(_controller!)
                  : const CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('✅ $correct   ❌ $incorrect', style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }
}
