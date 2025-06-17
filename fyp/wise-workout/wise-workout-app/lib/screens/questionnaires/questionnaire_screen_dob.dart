import 'package:flutter/material.dart';
import 'questionnaire_screen.dart';
import 'package:intl/intl.dart';

class QuestionnaireDobScreen extends StatefulWidget {
  final int step;
  final Map<String, dynamic> responses;

  const QuestionnaireDobScreen({
    super.key,
    required this.step,
    required this.responses,
  });

  @override
  State<QuestionnaireDobScreen> createState() => _QuestionnaireDobScreenState();
}

class _QuestionnaireDobScreenState extends State<QuestionnaireDobScreen> {
  DateTime? selectedDate;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleNext() {
    if (selectedDate != null) {
      final updatedResponses = {
        ...widget.responses,
        'dob': DateFormat('yyyy-MM-dd').format(selectedDate!)
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreen(
            step: widget.step + 1,
            responses: updatedResponses,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dobText = selectedDate != null
        ? DateFormat('MMMM d, yyyy').format(selectedDate!)
        : 'Tap to select your date of birth';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/questionnaire_bg.png'), // make sure path matches your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, size: 60, color: Colors.indigo),
                    const SizedBox(height: 20),
                    const Text(
                      "What's your date of birth?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_month, color: Colors.white),
                      label: Text(
                        dobText,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
