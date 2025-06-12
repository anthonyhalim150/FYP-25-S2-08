import 'package:flutter/material.dart';

final List<Map<String, dynamic>> premiumReviews = [
  {
    "text": "Absolutely love the premium features! Worth every cent.",
    "user": "Sophia",
    "stars": 5
  },
  {
    "text": "Great value, and the new workouts keep me coming back.",
    "user": "James",
    "stars": 4
  },
  {
    "text": "Lifetime plan is a steal for the content you get 😍",
    "user": "Lucas",
    "stars": 5
  },
];

class BuyPremiumScreen extends StatefulWidget {
  final bool isPremiumUser;
  const BuyPremiumScreen({Key? key, required this.isPremiumUser}) : super(key: key);

  @override
  State<BuyPremiumScreen> createState() => _BuyPremiumScreenState();
}

class _BuyPremiumScreenState extends State<BuyPremiumScreen> {
  int selectedPlan = 0; // 0: Monthly, 1: Annual, 2: Lifetime

  @override
  Widget build(BuildContext context) {
    if (widget.isPremiumUser) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Unlock Premium", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFFAF6EE),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _topBanner(),
          const SizedBox(height: 18),
          _sectionTitle("Premium Benefits"),
          _benefits(),
          const SizedBox(height: 20),
          _sectionTitle("What’s Included"),
          _includedFeatures(),
          const SizedBox(height: 20),
          _sectionTitle("Choose your Plan"),
          _planCards(context),
          const SizedBox(height: 18),
          _sectionTitle("What Premium Users Say"),
          _userReviews(),
          const SizedBox(height: 22),
          _moneyBackGuarantee(),
          const SizedBox(height: 18),
          _trialButton(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Here is the new top banner with icon/logo on top ---
  Widget _topBanner() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.purple.withOpacity(0.07),
          blurRadius: 9,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.workspace_premium,
          size: 70,
          color: Colors.amber[700], // gold premium color
        ),
        const SizedBox(height: 16),
        const Text(
          "Go Premium",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF071655),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Unlock all features, AI posture help, and cool avatars!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF071655)
      ),
    ),
  );

  Widget _benefits() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          _benefitTile(Icons.block, "100% Ad-free experience"),
          _benefitTile(Icons.emoji_emotions, "Exclusive avatar selections"),
          _benefitTile(Icons.smart_toy, "Auto-suggested plan with AI"),
          _benefitTile(Icons.play_circle_fill_rounded, "Step-by-step HD video tutorials"),
          _benefitTile(Icons.flash_on, "Priority support and faster updates"),
        ],
      ),
    ),
  );

  Widget _benefitTile(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.purple[300]),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );

  Widget _includedFeatures() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  Widget _planCards(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _planCard(
        context: context,
        idx: 0,
        name: "Monthly",
        price: "\$5.99",
        per: "/month",
        highlight: selectedPlan == 0,
      ),
      _planCard(
        context: context,
        idx: 1,
        name: "Annual",
        price: "\$49.99",
        per: "/year",
        highlight: selectedPlan == 1,
        bestValue: true,
      ),
      _planCard(
        context: context,
        idx: 2,
        name: "Lifetime",
        price: "\$129",
        per: "",
        highlight: selectedPlan == 2,
      ),
    ],
  );

  Widget _planCard({
    required BuildContext context,
    required int idx,
    required String name,
    required String price,
    required String per,
    bool highlight = false,
    bool bestValue = false,
  }) {
    final selectedColor = highlight ? Colors.purple[100] : Colors.white;
    final selectedBorder = highlight ? Colors.deepPurple : Colors.purple.shade100;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPlan = idx;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: highlight ? 2.7 : 1.2,
              color: selectedBorder,
            ),
            boxShadow: [
              if (highlight)
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.13),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.deepPurple : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.deepPurple : Colors.black87,
                  ),
                ),
                Text(
                  per,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                if (bestValue)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Text(
                        "Best Value",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userReviews() => Column(
    children: premiumReviews.map((review) {
      int stars = ((review["stars"] ?? 0) as num).clamp(0, 5).toInt();
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.06),
              blurRadius: 7,
              offset: const Offset(0, 1),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.account_circle_rounded, color: Colors.purple[300], size: 35),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(stars, (_) => Icon(Icons.star, size: 16, color: Colors.amber)),
                      ...List.generate(5 - stars, (_) => Icon(Icons.star_border, size: 16, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\"${review["text"]}\"",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text("- ${review["user"]}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );

  Widget _moneyBackGuarantee() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.green.shade300, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    child: Row(
      children: [
        Icon(Icons.verified, color: Colors.green[700], size: 32),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "7-Day Money Back Guarantee",
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                "Try any premium plan risk-free. Cancel anytime in the first 7 days for a full refund.",
                style: TextStyle(fontSize: 13.6),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _trialButton(BuildContext context) => Center(
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
        ),
        onPressed: () {
          // Handle trial start and pass selectedPlan (0, 1, 2)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                  'Start 7-day FREE Trial for ${["Monthly", "Annual", "Lifetime"][selectedPlan]} Plan')));
          // integrate purchase logic for backend?
        },
        child: const Text("Start 7-day FREE Trial"),
      ),
    ),
  );
}