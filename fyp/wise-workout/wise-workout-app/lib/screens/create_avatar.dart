import 'package:flutter/material.dart';

class CreateAvatarScreen extends StatefulWidget {
  final String username;
  final bool isPremiumUser;
  final String? currentAvatarPath;

  const CreateAvatarScreen({
    Key? key,
    required this.username,
    required this.isPremiumUser,
    this.currentAvatarPath,
  }) : super(key: key);

  @override
  State<CreateAvatarScreen> createState() => _CreateAvatarScreenState();
}

class _CreateAvatarScreenState extends State<CreateAvatarScreen> {
  static const List<String> avatarPaths = [
    // First 3 are free avatars
    'assets/avatars/free/free1.png',
    'assets/avatars/free/free2.png',
    'assets/avatars/free/free3.png',
    // Last 6 are premium avatars
    'assets/avatars/premium/premium2.png',
    'assets/avatars/premium/premium3.png',
    'assets/avatars/premium/premium4.png',
    'assets/avatars/premium/premium5.png',
    'assets/avatars/premium/premium6.png',
    'assets/avatars/premium/premium7.png',
  ];

  late String selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    selectedAvatarPath = widget.currentAvatarPath ?? avatarPaths.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Avatar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Selected Avatar
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(selectedAvatarPath),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 8),
            Text('@${widget.username}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            // Avatar selection grid
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
                    Row(
                      children: const [
                        Icon(Icons.arrow_back),
                        Spacer(),
                        Text(
                          'Avatar',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: GridView.builder(
                          itemCount: avatarPaths.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            final path = avatarPaths[index];
                            final isFree = index < 3;
                            final isChosen = selectedAvatarPath == path;
                            final isPremium = index >= 3;
                            final locked = isPremium && !widget.isPremiumUser;
                            return GestureDetector(
                              onTap: () {
                                if (locked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'This avatar is for premium users only!')),
                                  );
                                } else {
                                  setState(() {
                                    selectedAvatarPath = path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isChosen
                                      ? Colors.amber.withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: isChosen
                                          ? Colors.amber
                                          : Colors.transparent,
                                      width: 2),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Image.asset(
                                          path,
                                          width: 65,
                                          height: 65,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, _, __) => const Icon(
                                              Icons.image_not_supported,
                                              size: 30,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    if (locked)
                                      Container(
                                        color: Colors.white.withOpacity(0.7),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.lock_outline,
                                            color: Colors.amber, size: 30),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                        Navigator.pop(context, selectedAvatarPath);
                      },
                      child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}