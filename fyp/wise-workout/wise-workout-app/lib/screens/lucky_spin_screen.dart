import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LuckySpinScreen extends StatefulWidget {
  const LuckySpinScreen({super.key});

  @override
  State<LuckySpinScreen> createState() => _LuckySpinScreenState();
}

class _LuckySpinScreenState extends State<LuckySpinScreen> {
  final items = ['10 Coins', '50 Coins', 'Nothing', 'Premium 1 Day'];
  final controller = StreamController<int>();
  final secureStorage = FlutterSecureStorage();
  String? prizeLabel;
  bool isSpinning = false;
  bool canSpinFree = false;
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    checkSpinStatus();
  }

  Future<void> checkSpinStatus() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');

    final res = await http.get(
      Uri.parse('http://10.0.2.2:3000/lucky/spin/status'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final hasSpunToday = data['hasSpunToday'] ?? false;

      setState(() {
        canSpinFree = !hasSpunToday;
      });

      if (hasSpunToday && data['nextFreeSpinAt'] != null) {
        final nextFree = DateTime.parse(data['nextFreeSpinAt']);
        startCountdown(nextFree);
      }
    }
  }

  void startCountdown(DateTime nextFreeSpinAt) {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = nextFreeSpinAt.difference(now);

      if (diff.isNegative) {
        countdownTimer?.cancel();
        setState(() {
          canSpinFree = true;
          remainingTime = Duration.zero;
        });
      } else {
        setState(() => remainingTime = diff);
      }
    });
  }

  Future<void> spin({bool useCoins = false}) async {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
      prizeLabel = null;
    });

    final jwt = await secureStorage.read(key: 'jwt_cookie');

    final res = await http.get(
      Uri.parse('http://10.0.2.2:3000/lucky/spin${useCoins ? '?force=true' : ''}'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 403) {
      setState(() => isSpinning = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Already Spun'),
          content: const Text('You have already spun today. Use coins to spin again.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    if (res.statusCode != 200) {
      setState(() => isSpinning = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to spin. Please try again later.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final data = jsonDecode(res.body);
    final label = data['prize']['label'];
    final index = items.indexOf(label);

    if (index == -1) {
      setState(() => isSpinning = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Unknown prize "$label" received.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300)); // ensure UI is ready
    controller.add(index);

    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      prizeLabel = label;
      isSpinning = false;
      canSpinFree = false;
    });

    checkSpinStatus(); // Refresh status/timer
  }

  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    controller.close();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lucky Spin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: controller.stream,
                items: [
                  for (final item in items) FortuneItem(child: Text(item)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (prizeLabel != null)
              Text(
                '🎉 You won: $prizeLabel 🎉',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: canSpinFree ? () => spin() : null,
              child: const Text('SPIN'),
            ),
            if (!canSpinFree && remainingTime.inSeconds > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Next free spin in: ${formatDuration(remainingTime)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => spin(useCoins: true),
              child: const Text('SPIN AGAIN (50 Coins)'),
            ),
          ],
        ),
      ),
    );
  }
}
