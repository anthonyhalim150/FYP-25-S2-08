import 'package:flutter/material.dart';

class BuyPremiumScreen extends StatefulWidget {
  const BuyPremiumScreen({Key? key}) : super(key: key);

  @override
  State<BuyPremiumScreen> createState() => _BuyPremiumScreenState();
}

class _BuyPremiumScreenState extends State<BuyPremiumScreen> {
  int selectedPlan = 0;

  final List<Map<String, dynamic>> plans = [
    {
      'name': 'Monthly',
      'price': '\$5.99',
      'period': '/month',
      'highlight': false,
    },
    {
      'name': 'Annual',
      'price': '\$49.99',
      'period': '/year',
      'highlight': true,
    },
    {
      'name': 'Lifetime',
      'price': '\$129',
      'period': '',
      'highlight': false,
    },
  ];

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
            }),
        title: const Text('Premium Plan',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [
            const SizedBox(height: 10),
            _sectionTitle('Choose your Plan'),
            _planCards(),
            const SizedBox(height: 24),
            _sectionTitle('Premium Benefits'),
            _benefitsCard(),
            const SizedBox(height: 24),
            _sectionTitle("What's Included"),
            _includedCard(),
            const SizedBox(height: 18),
            _moneyBackCard(),
            const SizedBox(height: 80), // for button spacing
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: SizedBox(
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Start 7-day FREE Trial for ${plans[selectedPlan]['name']} Plan'
                  )));
            },
            child: const Text("Start 7-day FREE Trial"),
          ),
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

  Widget _planCards() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(plans.length, (idx) {
      bool highlight = selectedPlan == idx;
      bool bestValue = idx == 1;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => selectedPlan = idx),
          child: Container(
            margin: EdgeInsets.only(left: idx == 0 ? 0 : 8, right: idx == plans.length - 1 ? 0 : 8),
            decoration: BoxDecoration(
              color: highlight ? Colors.purple[50] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: highlight ? Colors.deepPurple : Colors.grey.shade300,
                width: highlight ? 2 : 1.3,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(plans[idx]['name'],
                    style: TextStyle(
                        color: highlight ? Colors.deepPurple : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 3),
                Text(plans[idx]['price'],
                    style: TextStyle(
                        color: highlight ? Colors.deepPurple : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text(plans[idx]['period'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    )),
                if (bestValue)
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
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
        ),
      );
    }),
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