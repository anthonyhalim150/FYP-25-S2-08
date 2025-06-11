import 'package:flutter/material.dart';
import '/services/wearable_service.dart'; // Make sure to create this file

class WearableScreen extends StatefulWidget {
  const WearableScreen({Key? key}) : super(key: key);

  @override
  State<WearableScreen> createState() => _WearableScreenState();
}

class _WearableScreenState extends State<WearableScreen> {
  String? selectedDevice;
  final WearableService _wearableService = WearableService();
  bool _isConnecting = false;
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Wearable section
            const Text(
              'Wearable',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Connect Your Device',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'FitQuest seamlessly connect to your fitness devices for seamless syncing of workouts, steps, and health stats—all in one place.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Device selection buttons
            _buildDeviceButton('SAMSUNG'),
            const SizedBox(height: 12),
            _buildDeviceButton('@WATCH'),

            if (_isConnected)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Connected to $selectedDevice',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            const Spacer(),

            // Connect button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isConnecting || selectedDevice == null || _isConnected)
                    ? null
                    : () => _connectToDevice(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF071655),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isConnecting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  _isConnected ? 'DISCONNECT' : 'CONNECT',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceButton(String deviceName) {
    final isSelected = selectedDevice == deviceName;

    return GestureDetector(
      onTap: () {
        if (!_isConnecting && !_isConnected) {
          setState(() {
            selectedDevice = deviceName;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F0FF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3D7EFF) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            deviceName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF3D7EFF) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _connectToDevice() async {
    if (selectedDevice == null) return;

    setState(() => _isConnecting = true);

    try {
      final success = await _wearableService.connectDevice(selectedDevice!);

      setState(() {
        _isConnected = success;
        _isConnecting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully connected to $selectedDevice')),
        );
      }
    } catch (e) {
      setState(() => _isConnecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection failed. Please try again.')),
      );
    }
  }

  Future<void> _disconnectDevice() async {
    setState(() => _isConnecting = true);

    try {
      // In a real app, you would call a disconnect method from your service
      await Future.delayed(const Duration(seconds: 1)); // Simulate disconnection

      setState(() {
        _isConnected = false;
        _isConnecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disconnected from $selectedDevice')),
      );
    } catch (e) {
      setState(() => _isConnecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnection failed')),
      );
    }
  }
}