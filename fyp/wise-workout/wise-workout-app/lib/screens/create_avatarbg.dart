import 'package:flutter/material.dart';

class AvatarBackgroundPickerScreen extends StatefulWidget {
  final String selectedBgPath;
  final String selectedAvatarPath; // <--- pass the avatar image path here!
  final bool isPremiumUser;

  const AvatarBackgroundPickerScreen({
    Key? key,
    required this.selectedBgPath,
    required this.selectedAvatarPath,
    required this.isPremiumUser,
  }) : super(key: key);

  @override
  State<AvatarBackgroundPickerScreen> createState() => _AvatarBackgroundPickerScreenState();
}

class _AvatarBackgroundPickerScreenState extends State<AvatarBackgroundPickerScreen> {
  static const List<String> bgPaths = [
    'assets/background/bg1.jpg',
    'assets/background/bg2.jpg',
    'assets/background/bg3.jpeg',
    'assets/background/bg4.jpg',
    'assets/background/bg5.jpg',
    'assets/background/bg6.jpg',
    'assets/background/bg7.jpg',
    'assets/background/bg8.jpg',
    'assets/background/bg9.jpg',
  ];

  late String chosenBg;

  @override
  void initState() {
    super.initState();
    chosenBg = widget.selectedBgPath.isNotEmpty ? widget.selectedBgPath : bgPaths[0];
  }

  Widget buildAvatarOnBg() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            chosenBg,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(widget.selectedAvatarPath),
          radius: 70,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Background", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          buildAvatarOnBg(),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFDCB39),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Background',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: GridView.builder(
                        itemCount: bgPaths.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                        ),
                        itemBuilder: (context, index) {
                          final path = bgPaths[index];
                          final isChosen = chosenBg == path;
                          return GestureDetector(
                            onTap: widget.isPremiumUser
                                ? () => setState(() { chosenBg = path; })
                                : null,
                            child: Opacity(
                              opacity: widget.isPremiumUser ? 1.0 : 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: isChosen
                                      ? Border.all(color: Colors.amber, width: 3)
                                      : null,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) =>
                                        Container(color: Colors.grey[300]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 60,
                      ),
                    ),
                    onPressed: () {
                      // Pop twice and return both avatar and bg
                      Navigator.pop(context, chosenBg);
                    },
                    child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 18)),
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