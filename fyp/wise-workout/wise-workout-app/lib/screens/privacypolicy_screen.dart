import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.deepPurple),
    ),
  );

  Widget bulletList(List<String> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items
        .map((item) => Padding(
      padding: const EdgeInsets.only(left: 6.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 15.5)),
          Expanded(child: Text(item, style: const TextStyle(fontSize: 15.5))),
        ],
      ),
    ))
        .toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Effective date: June 2024",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 18),
              Text(
                "FitQuest (\"we\", \"us\", or \"our\") values your privacy. This Privacy Policy explains how we collect, use, share, and protect your personal information when you use our workout mobile application.",
                style: const TextStyle(fontSize: 15.5),
              ),

              // SECTION 1
              sectionTitle("1. Information We Collect"),
              const SizedBox(height: 4),
              const Text("a) Personal Information:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
              bulletList([
                "Name, username, or nickname",
                "Email address",
                "Payment information (handled via secure third-party processors)",
                "Profile info (e.g., age, gender [optional], avatar selection)"
              ]),
              const SizedBox(height: 7),
              const Text("b) Usage Data:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
              bulletList([
                "Workout activity and progress",
                "App feature usage and frequency",
                "Device & log info (type, IP address, OS, crash logs)"
              ]),
              const SizedBox(height: 7),
              const Text("c) Cookies and Analytics:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                    "We may use cookies or similar tech, plus analytics services to improve your experience and analyze usage trends.",
                    style: TextStyle(fontSize: 15.5)),
              ),

              // SECTION 2
              sectionTitle("2. How We Use Your Information"),
              bulletList([
                "Operate and maintain the App",
                "Personalize your experience and workout plans",
                "Process subscription payments",
                "Respond to support requests",
                "Improve features and user experience",
                "Notify you about updates, offers, and changes (marketing is optional)"
              ]),

              // SECTION 3
              sectionTitle("3. How We Share Your Information"),
              bulletList([
                "Payment processors (e.g., Stripe, Apple, Google)",
                "Analytics/services that help operate and analyze the app",
                "Legal authorities if required by law or to protect rights/safety"
              ]),
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 4),
                child: Text(
                  "We never sell or rent your personal information.",
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
                ),
              ),

              // SECTION 4
              sectionTitle("4. Data Security"),
              const Padding(
                padding: EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  "We protect your data using industry-standard security. Sensitive data (such as payments) is managed by trusted third parties.",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 5
              sectionTitle("5. Your Choices"),
              bulletList([
                "You may access, update, or delete your account info via the app or by contacting us.",
                "You can opt out of marketing emails anytime."
              ]),

              // SECTION 6
              sectionTitle("6. Children’s Privacy"),
              const Padding(
                padding: EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  "FitQuest is not intended for children under 13. We do not knowingly collect info from under-13s. Contact us if you believe a child has used the app.",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 7
              sectionTitle("7. Changes to This Privacy Policy"),
              const Padding(
                padding: EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  "We may update this Policy. We will notify users of changes through the app or by other communication.",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 8
              sectionTitle("8. Contact Us"),
              const Padding(
                padding: EdgeInsets.only(left: 6.0, bottom: 18),
                child: Text(
                  "If you have any questions, contact us at:\ncyberguard150@gmail.com",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}