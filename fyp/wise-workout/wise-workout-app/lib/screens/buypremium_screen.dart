import 'package:flutter/material.dart';
import 'payment_screen.dart';

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
    {
      'name': 'Monthly',
      'price': '\$2.99',
      'period': '/month',
      'tokens': 4000,
      'durationDays': 30,
    },
    {
      'name': 'Annual',
      'price': '\$19.99',
      'period': '/year',
      'tokens': 19000,
      'durationDays': 365,
    },
    {
      'name': 'Lifetime',
      'price': '\$49',
      'period': '',
      'tokens': 99000,
      'durationDays': 36500, // 100 years
    },
  ];

  Future<void> _showBuyWithTokenConfirmation() async {
    final int neededTokens = (plans[selectedPlan]['tokens'] as num).toInt();
    final int durationDays = (plans[selectedPlan]['durationDays'] as num).toInt();
    String planName = plans[selectedPlan]['name'];
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: Text(
            "Are you sure you want to buy the $planName plan for $neededTokens tokens?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );
    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: SizedBox(
            height: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Processing your purchase..."),
                ],
              ),
            ),
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
      String premiumMsg;
      if (durationDays > 3650) {
        premiumMsg = "Congratulations! You're now a premium user for LIFE.";
      } else {
        premiumMsg =
        "Congratulations! You're a premium user for $durationDays days!";
      }
      // congratulations dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success!"),
          content: Text(premiumMsg),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Premium Plan',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
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
            _planCards(), // scrollable plans
            const SizedBox(height: 24),
            _sectionTitle('Premium Benefits'),
            _benefitsCard(),
            const SizedBox(height: 24),
            _sectionTitle("What's Included"),
            _includedCard(),
            const SizedBox(height: 18),
            _moneyBackCard(),
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
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
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
                      builder: (context) => PaymentScreen(
                        planName: planName,
                        price: price,
                      ),
                    ),
                  );
                },
                child: const Text("Start 7-day FREE Trial"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: userTokens >= (plans[selectedPlan]['tokens'] as num).toInt()
                    ? _showBuyWithTokenConfirmation
                    : null,
                child: Text(
                  "Buy with ${(plans[selectedPlan]['tokens'] as num).toInt()} Tokens",
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "You have $userTokens tokens",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple[400],
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              "(Tokens can be won on Lucky Spin!)",
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
            Text("You are Premium: ",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _planCards() => SizedBox(
    height: 160,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: plans.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, idx) {
        bool highlight = selectedPlan == idx;
        bool bestValue = idx == 1;
        return GestureDetector(
          onTap: () => setState(() => selectedPlan = idx),
          child: Container(
            width: 140,
            decoration: BoxDecoration(
              color: highlight ? Colors.purple[50] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: highlight ? Colors.deepPurple : Colors.grey.shade300,
                width: highlight ? 2 : 1.3,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plans[idx]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: highlight ? Colors.deepPurple : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  plans[idx]['price'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: highlight ? Colors.deepPurple : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  plans[idx]['period'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 17,
                      color: highlight ? Colors.deepPurple : Colors.grey[700],
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${(plans[idx]['tokens'] as num).toInt()} Tokens',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: highlight ? Colors.deepPurple : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 13.7,
                        ),
                      ),
                    ),
                  ],
                ),
                if (bestValue)
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Best Value',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  )
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _benefitsCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Column(
        children: [
          _benefitTile(Icons.block, "100% Ad-free experience"),
          _benefitTile(Icons.emoji_emotions, "Exclusive avatar selections"),
          _benefitTile(Icons.smart_toy, "Auto-suggested plan with AI"),
          _benefitTile(Icons.play_circle_filled,
              "Step-by-step HD video tutorials"),
          _benefitTile(Icons.flash_on,
              "Priority support and faster updates"),
        ],
      ),
    ),
  );

  Widget _benefitTile(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, color: Colors.purple[300]),
        const SizedBox(width: 14),
        Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            )),
      ],
    ),
  );

  Widget _includedCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("• Fitness plans for all levels", style: TextStyle(fontSize: 15)),
          SizedBox(height: 4),
          Text("• Advanced progress tracking", style: TextStyle(fontSize: 15)),
          SizedBox(height: 4),
          Text("• Access to new AI-powered features", style: TextStyle(fontSize: 15)),
          SizedBox(height: 4),
          Text("• Access future new content immediately", style: TextStyle(fontSize: 15)),
          SizedBox(height: 4),
          Text("• Support the app’s ongoing development ❤️", style: TextStyle(fontSize: 15)),
        ],
      ),
    ),
  );

  Widget _moneyBackCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green[700], size: 33),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "7-Day Money Back Guarantee\n",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text:
                    "Try any premium plan risk-free. Cancel anytime in the first 7 days for a full refund.",
                    style: TextStyle(color: Colors.black87, fontSize: 13.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}