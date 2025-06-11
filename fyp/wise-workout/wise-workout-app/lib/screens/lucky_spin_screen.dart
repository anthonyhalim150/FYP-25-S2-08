import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import '../services/lucky_spin_service.dart';

class LuckySpinScreen extends StatefulWidget {
  final int tokens;

  const LuckySpinScreen({Key? key, required this.tokens}) : super(key: key);

  @override
  State<LuckySpinScreen> createState() => _LuckySpinScreenState();
}

class _LuckySpinScreenState extends State<LuckySpinScreen> {
  final controller = StreamController<int>();
  final LuckySpinService luckySpinService = LuckySpinService();
  List<String> items = [];
  String? prizeLabel;
  bool isSpinning = false;
  bool canSpinFree = false;
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;
  int tokenCount = 0;

  @override
  void initState() {
    super.initState();
    tokenCount = widget.tokens; 
    loadPrizesAndStatus();
  }

  Future<void> loadPrizesAndStatus() async {
    try {
      items = await luckySpinService.fetchPrizes();
      await checkSpinStatus();
    } catch (_) {
      setState(() => items = []);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load prizes. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> checkSpinStatus() async {
    try {
      final data = await luckySpinService.checkSpinStatus();
      final hasSpunToday = data['hasSpunToday'] ?? false;
      setState(() {
        canSpinFree = !hasSpunToday;
        tokenCount = data['tokens'] ?? tokenCount;
      });
      if (hasSpunToday && data['nextFreeSpinAt'] != null) {
        final nextFree = DateTime.parse(data['nextFreeSpinAt']);
        startCountdown(nextFree);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load spin status. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
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

  Future<void> spin({bool useTokens = false}) async {
    if (isSpinning || items.isEmpty) return;
    setState(() {
      isSpinning = true;
      prizeLabel = null;
    });

    try {
      final data = await luckySpinService.spin(useTokens: useTokens);
      final label = data['prize']['label'];
      final index = items.indexWhere((item) => item.trim() == label.trim());

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

      await Future.delayed(const Duration(milliseconds: 300));
      controller.add(index);
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        prizeLabel = label;
        isSpinning = false;
        canSpinFree = false;
      });
      await checkSpinStatus();
    } catch (e) {
      setState(() => isSpinning = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString().replaceAll('Exception: ', '')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
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
      backgroundColor: const Color(0xFF172A74),
      body: SafeArea(
        child: items.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.amber))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      const SizedBox(width: 48),
                    ],
                  ),
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
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 310,
                          width: 310,
                          child: FortuneWheel(
                            selected: controller.stream,
                            animateFirst: false,
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
                  const SizedBox(height: 32),
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
                  if (!canSpinFree && remainingTime.inSeconds > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Next free spin in: ${formatDuration(remainingTime)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF172A74),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => spin(useTokens: true),
                    child: const Text('SPIN AGAIN (50 Tokens)'),
                  ),
                ],
              ),
      ),
    );
  }
}
