import 'package:flutter/material.dart';
import 'questionnaire_screen_2.dart';

class QuestionnaireScreen extends StatefulWidget {
  final int step;
  final Map<String, dynamic> responses;
  const QuestionnaireScreen({super.key, required this.step, required this.responses});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    heightController.addListener(_onTextChange);
    weightController.addListener(_onTextChange);
  }

  void _onTextChange() => setState(() {});

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void handleNext() {
    final updatedResponses = {
      ...widget.responses,
      'height_cm': heightController.text,
      'weight_kg': weightController.text,
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionnaireScreen2(
          step: widget.step + 1,
          responses: updatedResponses,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF9F7F2);
    final bool buttonEnabled = heightController.text.isNotEmpty && weightController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.fitness_center, color: Color(0xFFFFC700), size: 34),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        "Question 1 out of 9",
                        style: TextStyle(
                          color: Color(0xFFB7B8B8),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "What's your height?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: heightController,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                "cm",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        "What's your weight?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: weightController,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                "kg",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 38),
                      SizedBox(
                        width: 160,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: buttonEnabled ? handleNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonEnabled
                                ? const Color(0xFF0D1850)
                                : const Color(0xFFDBDBDB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          child: const Text("Next"),
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