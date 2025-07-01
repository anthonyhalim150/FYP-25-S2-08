import 'package:flutter/material.dart';

// Hardcoded messages, username and avatar
class ChatMessage {
  final String text;
  final bool isSelf;
  final String time;
  final String avatar;
  ChatMessage({
    required this.text,
    required this.isSelf,
    required this.time,
    required this.avatar,
  });
}

class ChatScreen extends StatefulWidget {
  final String friendName;
  final String friendHandle;
  final String friendAvatar;
  final bool isPremium;
  const ChatScreen({
    Key? key,
    required this.friendName,
    required this.friendHandle,
    required this.friendAvatar,
    this.isPremium = false,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// hardcoded
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage(
      text: "Hi",
      isSelf: false,
      time: "12:09",
      avatar: "assets/avatars/free/free2.png",
    ),
    ChatMessage(
      text: "Hi",
      isSelf: true,
      time: "12:09",
      avatar: "assets/avatars/premium/premium4.png",
    ),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(ChatMessage(
        text: _controller.text,
        isSelf: true,
        time: TimeOfDay.now().format(context),
        avatar: "assets/avatars/premium/premium4.png", // hardcoded avatar
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              color: const Color(0xFF141F5A),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 6),
                  // Friend Avatar
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.friendAvatar),
                    radius: 32,
                  ),
                  const SizedBox(width: 16),
                  // Name and Handle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friendName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          widget.friendHandle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isPremium)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Need to add Challenge logic
                      },
                      icon: const Icon(Icons.add, size: 15, color: Colors.white),
                      label: const Text(
                        "Challenge",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.yellow,
                        backgroundColor: const Color(0xFFFFCB35),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // CHAT MESSAGES
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                itemCount: messages.length,
                itemBuilder: (context, idx) {
                  final m = messages[idx];
                  return Align(
                    alignment: m.isSelf ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: m.isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!m.isSelf)
                          CircleAvatar(
                            backgroundImage: AssetImage(m.avatar),
                            radius: 20,
                          ),
                        if (!m.isSelf) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 10, bottom: 2,
                              left: m.isSelf ? 48 : 0,
                              right: m.isSelf ? 0 : 48,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: m.isSelf
                                  ? const Color(0xFFFFF2C3)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(m.isSelf ? 14 : 2),
                                bottomRight: Radius.circular(m.isSelf ? 2 : 14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              m.text,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (m.isSelf) const SizedBox(width: 8),
                        if (m.isSelf)
                          CircleAvatar(
                            backgroundImage: AssetImage(m.avatar),
                            radius: 20,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // MESSAGE INPUT FIELD
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Send a message...",
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCB35),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.send, color: Colors.black, size: 22),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}