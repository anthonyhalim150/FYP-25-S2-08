import 'package:flutter/material.dart';
import 'package:health/health.dart';
import '/services/wearable_service.dart';

class WearableScreen extends StatefulWidget {
  const WearableScreen({Key? key}) : super(key: key);

  @override
  State<WearableScreen> createState() => _WearableScreenState();
}

class _WearableScreenState extends State<WearableScreen> {
  String? selectedDevice;
  final WearableService _wearableService = WearableService();
  final Health _health = Health();
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
            _buildHeader(context),
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
              'FitQuest seamlessly connects to your fitness devices for syncing workouts, steps, and health stats—all in one place.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            _buildDeviceButton('SAMSUNG'),
            const SizedBox(height: 12),
            _buildDeviceButton('@WATCH'),
            const SizedBox(height: 12),
            _buildDeviceButton('HEALTH CONNECT'),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isConnecting || selectedDevice == null)
                    ? null
                    : () => _isConnected ? _disconnectDevice() : _connectToDevice(),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Wearable',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Transform.translate(
            offset: const Offset(-8, 0), // Shift 8 pixels to the left
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
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
      if (selectedDevice == 'SAMSUNG' || selectedDevice == '@WATCH') {
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
      } else if (selectedDevice == 'HEALTH CONNECT') {
        final types = [
          HealthDataType.STEPS,
          HealthDataType.HEART_RATE,
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ];
        final permissions = types.map((e) => HealthDataAccess.READ).toList();
        final isAuthorized = await _health.requestAuthorization(types, permissions: permissions);

        setState(() {
          _isConnected = isAuthorized;
          _isConnecting = false;
        });

        if (isAuthorized) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully connected to Health Connect')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to connect to Health Connect')),
          );
        }
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
      if (selectedDevice == 'HEALTH CONNECT') {
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }

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
