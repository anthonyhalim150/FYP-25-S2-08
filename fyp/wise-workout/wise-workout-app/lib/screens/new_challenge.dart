import 'package:flutter/material.dart';

class NewChallengeScreen extends StatefulWidget {
  final bool isPremiumUser;
  const NewChallengeScreen({Key? key, this.isPremiumUser = false}) : super(key: key);

  @override
  State<NewChallengeScreen> createState() => _NewChallengeScreenState();
}

class _NewChallengeScreenState extends State<NewChallengeScreen> {
  final Map<String, IconData> exerciseIcons = {
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

  List<Map<String, dynamic>> challengeTypes = [
    { "label": "Push Ups", "type": "reps", "enabled": false, "value": 10, "min": 0, "max": 500, "step": 1 },
    { "label": "Plank", "type": "duration", "enabled": false, "value": 30, "min": 0, "max": 600, "step": 5 },
    { "label": "Jumping Jacks", "type": "reps", "enabled": false, "value": 20, "min": 0, "max": 500, "step": 5 },
    { "label": "Sit Ups", "type": "reps", "enabled": false, "value": 10, "min": 0, "max": 500, "step": 1 },
    { "label": "Burpees", "type": "reps", "enabled": false, "value": 10, "min": 0, "max": 500, "step": 1 },
    { "label": "Mountain Climbers", "type": "reps", "enabled": false, "value": 20, "min": 0, "max": 500, "step": 5 },
    { "label": "High Knees", "type": "reps", "enabled": false, "value": 30, "min": 0, "max": 500, "step": 5 },
    { "label": "Squats", "type": "reps", "enabled": false, "value": 15, "min": 0, "max": 500, "step": 1 },
    { "label": "Lunges", "type": "reps", "enabled": false, "value": 14, "min": 0, "max": 500, "step": 2 },
    { "label": "Wall Sit", "type": "duration", "enabled": false, "value": 20, "min": 0, "max": 600, "step": 5 },
  ];

  // TODO: Replace this with your backend call to get the user's premium friend list.
  List<String> allUsers = ['Alex', 'Jordan', 'Sam', 'Maria', 'Taylor'];
  List<String> selectedUsers = [];

  // Example: Simulate backend fetch of premium friends
  @override
  void initState() {
    super.initState();
    //_fetchPremiumFriends(); // Uncomment this when implementing backend call
  }

  // Future<void> _fetchPremiumFriends() async {
  //   // TODO: Replace with your backend API call or use a provider, bloc, etc.
  //   // Example:
  //   // var friends = await YourApi.getPremiumFriends();
  //   // setState(() {
  //   //   allUsers = friends;
  //   // });
  // }

  Widget _buildChallengeCard(int idx) {
    final c = challengeTypes[idx];
    final bool isEnabled = c["enabled"];
    final color = isEnabled ? const Color(0xFFFFE066) : Colors.white10;

    return Card(
      elevation: isEnabled ? 6 : 2,
      color: color.withOpacity(isEnabled ? 0.24 : 0.13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isEnabled ? Colors.amber : Colors.white12,
          width: isEnabled ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            c["enabled"] = !isEnabled;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isEnabled,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        c["enabled"] = val!;
                      });
                    },
                  ),
                  Icon(
                    exerciseIcons[c["label"]] ?? Icons.sports_kabaddi,
                    color: isEnabled ? Colors.amber : Colors.white38,
                    size: 28,
                  ),
                  const SizedBox(width: 11),
                  Text(
                    c["label"],
                    style: TextStyle(
                        color: Colors.white.withOpacity(isEnabled ? 1.0 : 0.72),
                        fontWeight: FontWeight.w600,
                        fontSize: 17.5),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: isEnabled ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 160),
                    child: Icon(Icons.check_circle, color: Colors.amber, size: 23),
                  )
                ],
              ),
              if (isEnabled)
                Padding(
                  padding: const EdgeInsets.only(left: 3, top: 6, right: 3, bottom: 3),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 11),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.11),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          c["type"] == "duration" ? "Duration" : "Reps",
                          style: const TextStyle(
                              color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.amber),
                        onPressed: c['value'] > c['min']
                            ? () => setState(() => c['value'] = c['value'] - c['step'])
                            : null,
                      ),
                      Container(
                        width: 42,
                        alignment: Alignment.center,
                        child: Text(
                          '${c['value']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 2),
                        child: Text(
                          c['type'] == 'duration' ? 'sec' : '',
                          style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.amber),
                        onPressed: c['value'] < c['max']
                            ? () => setState(() => c['value'] = c['value'] + c['step'])
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSelect() {
    if (!widget.isPremiumUser) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              "Challenge People",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17),
            ),
          ),
          ...allUsers.map((user) => GestureDetector(
            onTap: () {
              setState(() {
                if (selectedUsers.contains(user)) {
                  selectedUsers.remove(user);
                } else {
                  selectedUsers.add(user);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: selectedUsers.contains(user)
                    ? Colors.amber.withOpacity(0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: selectedUsers.contains(user)
                      ? Colors.amber
                      : const Color(0xFFFFE066),
                  child: Text(
                    user[0],
                    style: const TextStyle(color: Color(0xFF071655), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                trailing: selectedUsers.contains(user)
                    ? const Icon(Icons.check_circle, color: Colors.amber, size: 24)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.white70),
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _showChallengeSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232954),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.amber, size: 32),
            SizedBox(width: 12),
            Text("Challenge Sent!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "Your challenge has been sent.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.amber, textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitChallengeToBackend(
      List<Map<String, dynamic>> selected, List<String> selectedFriends) async {
    // TODO [BACKEND]: Replace this with your POST/PUT API call!
    // Example:
    // await YourApi.sendChallenge(selected, selectedFriends);
    // You might want to handle errors, loading state etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071655),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("New Challenge",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 500 ? 440 : double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 22,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Select Challenges',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.4),
                  ),
                ),
                ...List.generate(challengeTypes.length, (i) => _buildChallengeCard(i)),
                const SizedBox(height: 16),
                _buildUserSelect(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final selected = challengeTypes
                            .where((c) => c['enabled'] == true)
                            .map((c) => {
                          "label": c['label'],
                          "type": c['type'],
                          "value": c['value']
                        })
                            .toList();

                        // TODO [BACKEND]: Send 'selected' and 'selectedUsers' to your backend here!
                        // Uncomment and implement your backend function:
                        // await _submitChallengeToBackend(selected, selectedUsers);

                        _showChallengeSentDialog();
                      },
                      icon: const Icon(Icons.send, color: Color(0xFF071655)),
                      label: const Text(
                        "Start Challenge",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF071655)),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.amber[200]),
                        shadowColor: MaterialStateProperty.all(Colors.amber[900]),
                        elevation: MaterialStateProperty.all(6),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 29, vertical: 14)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}