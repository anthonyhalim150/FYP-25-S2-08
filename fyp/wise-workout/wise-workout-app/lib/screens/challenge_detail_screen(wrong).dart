import 'package:flutter/material.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> challenge;
  const ChallengeDetailScreen({Key? key, required this.challenge}) : super(key: key);

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late bool accepted;
  late bool completed;
  late List<dynamic> details;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    accepted = widget.challenge["accepted"] ?? false;
    completed = widget.challenge["completed"] ?? false;
    details = widget.challenge["details"] ?? [];
    controllers = List.generate(
      details.length,
          (i) => TextEditingController(text: details[i]["did"]?.toString() ?? ""),
    );
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void acceptChallenge() {
    setState(() {
      accepted = true;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Challenge accepted!")));
  }

  void completeChallenge() {
    bool anyError = false;
    for (int i = 0; i < details.length; i++) {
      final input = controllers[i].text.trim();
      final val = int.tryParse(input);
      if (val == null || val < 0) {
        anyError = true;
        break;
      }
    }
    if (anyError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill in all your results (numbers only).")),
      );
      return;
    }
    // Save user inputs
    for (int i = 0; i < details.length; i++) {
      final val = int.tryParse(controllers[i].text.trim());
      details[i]["did"] = val ?? details[i]['value'];
    }
    setState(() {
      completed = true;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Challenge completed!")));
  }

  Icon getExerciseIcon(String label) {
    const iconMap = {
      "Push Ups": Icons.accessibility_new,
      "Plank": Icons.self_improvement,
      "Jumping Jacks": Icons.directions_run,
      "Sit Ups": Icons.fitness_center,
      "Burpees": Icons.flash_on,
      "Mountain Climbers": Icons.terrain,
      "High Knees": Icons.run_circle,
      "Squats": Icons.directions_walk,
      "Lunges": Icons.airline_seat_legroom_normal,
      "Wall Sit": Icons.event_seat,
    };
    return Icon(iconMap[label] ?? Icons.sports_kabaddi,
        color: Colors.amber, size: 32);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.challenge['opponent']} Challenge"),
        backgroundColor: const Color(0xFF071655),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF071655),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.challenge['opponent']} challenged you!",
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              const Text(
                "Your Challenge:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              const SizedBox(height: 8),
              ...List.generate(details.length, (idx) {
                final c = details[idx];
                final unit = c["type"] == "duration" ? "sec" : "reps";
                final isInputMode = accepted && !completed;
                final bool isCompleted = completed;
                final didValue = c['did'] ?? "";
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.amber.withOpacity(0.14), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      getExerciseIcon(c['label']),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['label'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.5)),
                            const SizedBox(height: 3),
                            Text(
                              "Target: ${c['value']} $unit",
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 14.5),
                            ),
                            const SizedBox(height: 6),
                            if (isInputMode)
                              Row(
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: controllers[idx],
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      decoration: InputDecoration(
                                        hintText: 'Your result',
                                        hintStyle: TextStyle(
                                            color:
                                            Colors.amber.shade200),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 9),
                                        filled: true,
                                        fillColor:
                                        Colors.amber.withOpacity(0.10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.amber, width: 1.2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.amber, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(unit,
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            if (isCompleted)
                              Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.greenAccent, size: 23),
                                  const SizedBox(width: 7),
                                  Text(
                                    "You did: $didValue $unit",
                                    style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              if (!accepted)
                Center(
                  child: ElevatedButton(
                    onPressed: acceptChallenge,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: const Color(0xFF071655),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 16)),
                    child: const Text("Accept Challenge",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              if (accepted && !completed)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.emoji_events_rounded,
                        color: Color(0xFF071655)),
                    onPressed: completeChallenge,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: const Color(0xFF071655),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 16)),
                    label: const Text("I Did The Challenge!",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              if (completed)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events, size: 52, color: Colors.amber),
                        const SizedBox(height: 10),
                        const Text("Completed!",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                        const SizedBox(height: 25),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: const Color(0xFF071655),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: () => Navigator.of(context).pop({
                            ...widget.challenge,
                            "accepted": accepted,
                            "completed": completed,
                            "details": details,
                          }),
                          label: const Text("Back To Challenges",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}