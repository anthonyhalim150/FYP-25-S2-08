import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'questionnaire_screen_gender.dart';

class QuestionnaireDobScreen extends StatefulWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;
  const QuestionnaireDobScreen({
    super.key,
    required this.step,
    this.totalSteps = 9,
    required this.responses,
  });
  @override
  State<QuestionnaireDobScreen> createState() => _QuestionnaireDobScreenState();
}

class _QuestionnaireDobScreenState extends State<QuestionnaireDobScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.responses['dob'] != null) {
      selectedDate = DateTime.tryParse(widget.responses['dob']);
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(now.year - 18),
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
      widget.responses['dob'] = DateFormat('yyyy-MM-dd').format(selectedDate!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreenGender(
            step: widget.step,
            totalSteps: widget.totalSteps,
            responses: widget.responses,
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
    const background = Color(0xFFF9F7F2);
    const yellow = Color(0xFFFFC832);
    const darkBlue = Color(0xFF0D1850);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black, size: 22),
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
                    children: [
                      const SizedBox(height: 38),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          "What's your date of birth?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.94,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27),
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
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month, color: Colors.black54),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    dobText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedDate == null ? Colors.black38 : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 47),
                      SizedBox(
                        width: 140,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: selectedDate != null ? _handleNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedDate != null ? darkBlue : const Color(0xFFD6D6D8),
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
                          child: const Text("Next"),
                        ),
                      ),
                      const SizedBox(height: 20),
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