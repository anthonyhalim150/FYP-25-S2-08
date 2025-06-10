import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LuckySpinScreen extends StatefulWidget {
  const LuckySpinScreen({Key? key}) : super(key: key);

  @override
  State<LuckySpinScreen> createState() => _LuckySpinScreenState();
}

class _LuckySpinScreenState extends State<LuckySpinScreen> {
  final items = [
    '   10 Tokens', '   1 Freeze', '   50 Tokens', '   3 Freezes', '   1 Tokens',
    '   1 Avatar', '   1 Background', '   150 Tokens', '   5 Freezes', '   1 Day Trial'
  ];
  final controller = StreamController<int>();
  final secureStorage = FlutterSecureStorage();

  String? prizeLabel;
  bool isSpinning = false;
  bool canSpinFree = false;
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;
  int tokenCount = 100; // Replace with fetched tokens from backend

  @override
  void initState() {
    super.initState();
    checkSpinStatus();
    // TODO: Replace tokenCount with fetch from backend
  }

  Future<void> checkSpinStatus() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.get(
      Uri.parse('http://10.0.2.2:3000/lucky/spin/status'),
      headers: {'Cookie': 'session=$jwt','Content-Type': 'application/json',},
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final hasSpunToday = data['hasSpunToday'] ?? false;
      setState(() {
        canSpinFree = !hasSpunToday;
        tokenCount = data['tokens'] ?? tokenCount;
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
      headers: {'Cookie': 'session=$jwt','Content-Type': 'application/json',},
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
      backgroundColor: const Color(0xFF172A74), // Deep blue background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom AppBar with back arrow and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Lucky Spin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // For symmetry
              ],
            ),
            // Tokens display
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "$tokenCount Tokens",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Spin the Wheel headline
            const Text(
              'Spin The Wheel!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            // Fortune Wheel with golden center
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 310,
                    width: 310,
                    child: FortuneWheel(
                      selected: controller.stream,
                      items: [
                        for (final item in items)
                          FortuneItem(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            style: FortuneItemStyle(
                              color: items.indexOf(item) % 2 == 0
                                  ? const Color(0xFF3A5AD9)
                                  : const Color(0xFF7BB3FF),
                              borderColor: Colors.white,
                              borderWidth: 3,
                            ),
                          ),
                      ],
                      indicators: <FortuneIndicator>[
                        FortuneIndicator(
                          alignment: Alignment.topCenter,
                          child: TriangleIndicator(
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Golden center circle
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffFFD700),
                          Color(0xffFFFACD),
                          Color(0xffFFA500),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 12,
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ],
              ),
            ),
            // Space below wheel
            const SizedBox(height: 32),
            // Win message
            if (prizeLabel != null)
              Text(
                '🎉 You won: $prizeLabel 🎉',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            if (prizeLabel != null) const SizedBox(height: 18),
            // Spin button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: canSpinFree ? () => spin() : null,
              child: const Text('SPIN'),
            ),
            // Timer (optional, show next free spin)
            if (!canSpinFree && remainingTime.inSeconds > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Next free spin in: ${formatDuration(remainingTime)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            const SizedBox(height: 10),
            // Spin again button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF172A74),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => spin(useCoins: true),
              child: const Text('SPIN AGAIN (50 Tokens)'),
            ),
          ],
        ),
      ),
    );
  }
}