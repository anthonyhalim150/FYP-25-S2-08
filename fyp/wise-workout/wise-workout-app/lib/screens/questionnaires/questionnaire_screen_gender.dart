import 'package:flutter/material.dart';
import 'questionnaire_screen.dart';

class QuestionnaireScreenGender extends StatefulWidget {
  final int step;
  final int totalSteps;
  final Map<String, dynamic> responses;
  const QuestionnaireScreenGender({
    super.key,
    required this.step,
    this.totalSteps = 9,
    required this.responses,
  });

  @override
  State<QuestionnaireScreenGender> createState() => _QuestionnaireScreenGenderState();
}

class _QuestionnaireScreenGenderState extends State<QuestionnaireScreenGender> {
  int selectedIndex = -1;
  final List<String> options = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    final previous = widget.responses['gender'];
    if (previous != null) {
      final idx = options.indexWhere((opt) => opt.toLowerCase() == previous.toString().toLowerCase());
      if (idx != -1) selectedIndex = idx;
    }
  }

  void handleNext() {
    if (selectedIndex != -1) {
      widget.responses['gender'] = options[selectedIndex];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionnaireScreen(
            step: widget.step + 1,
            totalSteps: widget.totalSteps,
            responses: widget.responses,
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
                      Text(
                        "Question ${widget.step} out of ${widget.totalSteps}",
                        style: const TextStyle(
                          color: Color(0xFFB7B8B8),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          "What is your gender?",
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
                      ...List.generate(options.length, (i) {
                        final selected = selectedIndex == i;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 0),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 54,
                              decoration: BoxDecoration(
                                color: selected ? yellow : Colors.white,
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
