import 'package:flutter/material.dart';
import 'payment_screen.dart';
import '../widgets/plan_cards_widget.dart';
import '../widgets/benefits_widget.dart';
import '../widgets/included_widget.dart';
import '../widgets/money_back_widget.dart';

class BuyPremiumScreen extends StatefulWidget {
  const BuyPremiumScreen({Key? key}) : super(key: key);

  @override
  State<BuyPremiumScreen> createState() => _BuyPremiumScreenState();
}

class _BuyPremiumScreenState extends State<BuyPremiumScreen> {
  int selectedPlan = 0;
  int userTokens = 100000;
  bool isPremium = true;
  DateTime? premiumExpiry = DateTime.now().add(const Duration(days: 38));
  final List<Map<String, dynamic>> plans = [
    { 'name': 'Monthly', 'price': '\$2.99', 'period': '/month', 'tokens': 4000, 'durationDays': 30, },
    { 'name': 'Annual', 'price': '\$19.99', 'period': '/year', 'tokens': 19000, 'durationDays': 365, },
    { 'name': 'Lifetime', 'price': '\$49', 'period': '', 'tokens': 99000, 'durationDays': 36500, },
  ];

  Future<void> _showBuyWithTokenConfirmation() async {
    final int neededTokens = (plans[selectedPlan]['tokens'] as num).toInt();
    final int durationDays = (plans[selectedPlan]['durationDays'] as num).toInt();
    String planName = plans[selectedPlan]['name'];
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: Text("Are you sure you want to buy the $planName plan for $neededTokens tokens?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
        ],
      ),
    );
    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: SizedBox(height: 80, child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [CircularProgressIndicator(), SizedBox(height: 16), Text("Processing your purchase...")]))
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        userTokens -= neededTokens;
        isPremium = true;
        premiumExpiry = DateTime.now().add(Duration(days: durationDays));
      });
      String premiumMsg =
      (durationDays > 3650)
          ? "Congratulations! You're now a premium user for LIFE."
          : "Congratulations! You're a premium user for $durationDays days!";
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success!"),
          content: Text(premiumMsg),
          actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () { Navigator.pop(context); },
        ),
        title: const Text(
          'Premium Plan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [
            if (isPremium) ...[
              _premiumDurationCard(),
              const SizedBox(height: 13),
            ],
            const SizedBox(height: 10),
            _sectionTitle('Choose your Plan'),
            PlanCardsWidget(
              plans: plans,
              selectedPlan: selectedPlan,
              onSelected: (i) => setState(() => selectedPlan = i),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Premium Benefits'),
            const BenefitsWidget(),
            const SizedBox(height: 24),
            _sectionTitle("What's Included"),
            const IncludedWidget(),
            const SizedBox(height: 18),
            const MoneyBackWidget(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 52, width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  String planName = plans[selectedPlan]['name'];
                  String priceString = plans[selectedPlan]['price'];
                  double price = double.tryParse(priceString.replaceAll('\$', '')) ?? 0.0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(planName: planName, price: price),
                    ),
                  );
                },
                child: const Text("Start 7-day FREE Trial"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48, width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: userTokens >= (plans[selectedPlan]['tokens'] as num).toInt()
                    ? _showBuyWithTokenConfirmation
                    : null,
                child: Text("Buy with ${(plans[selectedPlan]['tokens'] as num).toInt()} Tokens"),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "You have $userTokens tokens",
              style: TextStyle(fontSize: 14, color: Colors.deepPurple[400], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text("(Tokens can be won on Lucky Spin!)",
              style: TextStyle(fontSize: 12, color: Colors.deepPurple[200]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _premiumDurationCard() {
    String durationText = '';
    if (premiumExpiry != null) {
      final daysLeft = premiumExpiry!.difference(DateTime.now()).inDays;
      if (daysLeft > 3650) {
        durationText = "Lifetime Premium";
      } else if (daysLeft > 0) {
        durationText = "$daysLeft days left";
      } else {
        durationText = "Expired";
      }
    } else {
      durationText = "Active";
    }
    return Card(
      color: Colors.lightGreen[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.amber[800]),
            const SizedBox(width: 14),
            Text("You are Premium: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(durationText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xFF071655)),
    ),
  );
}