import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionnaireScreen5 extends StatefulWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;

  const QuestionnaireScreen5({
    super.key,
    required this.step,
    this.totalSteps = 5,
    required this.responses,
  });

  @override
  State<QuestionnaireScreen5> createState() => _QuestionnaireScreen5State();
}

class _QuestionnaireScreen5State extends State<QuestionnaireScreen5> {
  int selectedIndex = -1;
  bool isSubmitting = false;
  final backendUrl = "http://10.0.2.2:3000";

  final List<String> options = [
    'No',
    'Yes, Minor (e.g., sore knee)',
    'Yes, Major (e.g., heart condition)',
    'Prefer Not to Say',
  ];

  Future<void> handleNext() async {
    if (selectedIndex == -1) return;

    final fullResponses = {
      ...widget.responses,
      'injuryStatus': options[selectedIndex],
    };

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/questionnaire/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fullResponses),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submission failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/questionnaire_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: LinearProgressIndicator(
                            value: widget.step / widget.totalSteps,
                            color: Colors.purpleAccent,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.health_and_safety, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'DO YOU HAVE ANY\nINJURIES OR CONDITIONS?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.health_and_safety, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(options.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.purpleAccent : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                options[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? Colors.purpleAccent : Colors.white38,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("FINISH →", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
