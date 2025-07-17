import 'package:flutter/material.dart';
import 'questionnaire_screen_7.dart';

class QuestionnaireScreen6 extends StatefulWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;
  const QuestionnaireScreen6({
    super.key,
    required this.step,
    this.totalSteps = 9,
    required this.responses,
  });

  @override
  State<QuestionnaireScreen6> createState() => _QuestionnaireScreen6State();
}

class _QuestionnaireScreen6State extends State<QuestionnaireScreen6> {
  int selectedIndex = -1;
  final List<String> options = [
    'Body Weight',
    'With Equipment',
    'Both',
  ];

  void handleNext() {
    if (selectedIndex != -1) {
      final updatedResponses = {
        ...widget.responses,
        'exercise_type': options[selectedIndex],
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreen7(
            step: widget.step + 1,
            responses: updatedResponses,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool buttonEnabled = selectedIndex != -1;
    const background = Color(0xFFF9F7F2);
    const yellow = Color(0xFFFFC832);
    const darkBlue = Color(0xFF0D1850);
    const gray = Color(0xFFD6D6D8);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.fitness_center, color: yellow, size: 28),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 38),
                      const Text(
                        "Question 4 out of 9",
                        style: TextStyle(
                          color: Color(0xFFB7B8B8),
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          "Do you prefer body weight\nexercises, equipment, or both?",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 21,
                            color: Colors.black,
                            height: 1.19,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 23),
                      // Options
                      ...List.generate(options.length, (i) {
                        final selected = selectedIndex == i;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: MediaQuery.of(context).size.width * 0.82,
                              height: 40,
                              decoration: BoxDecoration(
                                color: selected ? yellow : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Text(
                                  options[i],
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    color: Colors.black,
                                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                                    letterSpacing: 0.08,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 42),
                      // Next button
                      SizedBox(
                        width: 140,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: buttonEnabled ? handleNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonEnabled ? darkBlue : gray,
                            foregroundColor: buttonEnabled ? Colors.white : Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          child: const Text("Next"),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}