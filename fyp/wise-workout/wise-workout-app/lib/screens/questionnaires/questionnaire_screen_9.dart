import 'package:flutter/material.dart';

class QuestionnaireScreen9 extends StatelessWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;
  const QuestionnaireScreen9({
    super.key,
    required this.step,
    this.totalSteps = 9,
    required this.responses,
  });

  double get bmiValue {
    final heightCm = responses['height_cm'];
    final weightKg = responses['weight_kg'];
    final h = double.tryParse(heightCm?.toString() ?? '');
    final w = double.tryParse(weightKg?.toString() ?? '');
    if (h != null && w != null && h > 0) {
      return double.parse((w / ((h / 100) * (h / 100))).toStringAsFixed(1));
    }
    return 0.0;
  }

  String get bmiCategory {
    final bmi = bmiValue;
    if (bmi == 0) return '';
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFC832);
    const darkBlue = Color(0xFF0D1850);
    const background = Color(0xFFF9F7F2);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Icon(Icons.fitness_center, color: yellow, size: 28),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      const Text(
                        "Result",
                        style: TextStyle(
                          color: Color(0xFFB7B8B8),
                          fontWeight: FontWeight.w400,
                          fontSize: 19,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Your BMI is",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // BMI BOX
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          children: [
                            Text(
                              bmiValue == 0 ? '-' : bmiValue.toStringAsFixed(0),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 44,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bmiCategory,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Click to learn more!",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 54),

                      // DONE BUTTON
                      SizedBox(
                        width: 140,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            foregroundColor: Colors.white,
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
                          child: const Text("Done"),
                        ),
                      ),
                      const SizedBox(height: 32),
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