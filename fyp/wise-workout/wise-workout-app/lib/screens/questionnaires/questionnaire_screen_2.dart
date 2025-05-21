import 'package:flutter/material.dart';
import 'questionnaire_screen_3.dart';

class QuestionnaireScreen2 extends StatefulWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;

  const QuestionnaireScreen2({
    super.key,
    required this.step,
    this.totalSteps = 5,
    required this.responses,
  });

  @override
  State<QuestionnaireScreen2> createState() => _QuestionnaireScreen2State();
}

class _QuestionnaireScreen2State extends State<QuestionnaireScreen2> {
  int selectedIndex = -1;

  final List<String> options = [
    'Lose Weight',
    'Build Muscle',
    'Stay Healthy',
    'Improve Endurance',
    'Other',
  ];

  void handleNext() {
    if (selectedIndex != -1) {
      final updatedResponses = {
        ...widget.responses,
        'fitness_goal': options[selectedIndex],
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreen3(
            step: widget.step + 1,
            responses: updatedResponses,
          ),
        ),
      );
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
                      Icon(Icons.flag, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'WHAT IS YOUR\nFITNESS GOAL?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.flag, color: Colors.amber),
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
                                style: TextStyle(
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
                      onPressed: handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("NEXT →", style: TextStyle(fontSize: 16)),
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
