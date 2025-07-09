import 'dart:async';
import 'package:flutter/material.dart';
import '../services/message_service.dart';

class ChatScreen extends StatefulWidget {
  final int friendId;
  final String friendName;
  final String friendHandle;
  final String friendAvatar;
  final String friendBackground;
  final bool isPremium;
  const ChatScreen({
    Key? key,
    required this.friendId,
    required this.friendName,
    required this.friendHandle,
    required this.friendAvatar,
    required this.friendBackground,
    this.isPremium = false,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageService _messageService = MessageService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> messages = [];
  bool loading = true;
  int? myUserId;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _pollingTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => _fetchNewMessages());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      loading = true;
    });
    try {
      final data = await _messageService.getConversation(widget.friendId);
      setState(() {
        messages = data['messages'] ?? [];
        myUserId = int.tryParse(data['myUserId'].toString());
        loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      setState(() {
        messages = [];
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load messages")),
      );
    }
  }

  Future<void> _fetchNewMessages() async {
    try {
      final data = await _messageService.getConversation(widget.friendId);
      final fetchedMessages = data['messages'] ?? [];
      if (fetchedMessages.isEmpty) return;

      // Remove optimistic (id: null) messages if a matching real one comes from backend
      for (final serverMsg in fetchedMessages) {
        messages.removeWhere(
              (msg) =>
          msg['id'] == null &&
              msg['sender_id'] == serverMsg['sender_id'] &&
              msg['content'] == serverMsg['content'],
        );
      }

      // Only add new server messages not already in messages (by id)
      final existingIds =
      messages.where((m) => m['id'] != null).map((m) => m['id']).toSet();
      final trulyNewMessages = fetchedMessages
          .where(
            (serverMsg) =>
        serverMsg['id'] != null &&
            !existingIds.contains(serverMsg['id']),
      )
          .toList();
      if (trulyNewMessages.isNotEmpty) {
        setState(() {
          messages.addAll(trulyNewMessages);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (_) {}
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty || myUserId == null) return;
    try {
      // Optimistically add the message
      final myLastMsg = messages.lastWhere(
            (msg) =>
        (msg['sender_id'] is int
            ? msg['sender_id']
            : int.tryParse(msg['sender_id'].toString())) == myUserId,
        orElse: () => null,
      );
      final myAvatar = myLastMsg != null ? myLastMsg['sender_avatar'] ?? '' : '';
      final myBackground = myLastMsg != null
          ? myLastMsg['sender_background'] ?? 'assets/background/black.jpg'
          : 'assets/background/black.jpg';

      final newMessage = {
        'id': null, // Placeholder; server will assign actual id
        'sender_id': myUserId,
        'content': content,
        'sender_avatar': myAvatar,
        'sender_background': myBackground,
      };
      setState(() {
        messages.add(newMessage);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _controller.clear();

      await _messageService.sendMessage(widget.friendId, content);
      // Server message will replace optimistic one in polling
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send message")),
      );
    }
  }

  Widget _profileCircle({
    required String background,
    required String avatar,
    double size = 64,
    double avatarRadius = 28,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(background),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          backgroundImage: AssetImage(avatar),
          radius: avatarRadius,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 6),
                  _profileCircle(
                    background: widget.friendBackground,
                    avatar: widget.friendAvatar,
                    size: 64,
                    avatarRadius: 28,
                  ),
                  const SizedBox(width: 16),
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
                      onPressed: () {},
                      icon:
                      const Icon(Icons.add, size: 15, color: Colors.white),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
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
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 10),
                itemCount: messages.length,
                itemBuilder: (context, idx) {
                  final m = messages[idx];
                  final senderId = m['sender_id'] is int
                      ? m['sender_id']
                      : int.tryParse(m['sender_id'].toString());
                  final isSelf =
                      myUserId != null && senderId == myUserId;
                  final avatarPath = m['sender_avatar'] ?? '';
                  final backgroundPath = m['sender_background'] ??
                      'assets/background/black.jpg';
                  return Align(
                    alignment: isSelf
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isSelf
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isSelf)
                          _profileCircle(
                            background: backgroundPath,
                            avatar: avatarPath,
                            size: 40,
                            avatarRadius: 17,
                          ),
                        if (isSelf) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 2,
                              left: isSelf ? 0 : 48,
                              right: isSelf ? 48 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelf
                                  ? const Color(0xFFFFF2C3)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(isSelf ? 2 : 14),
                                bottomRight:
                                Radius.circular(isSelf ? 14 : 2),
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
                              m['content'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (!isSelf) const SizedBox(width: 8),
                        if (!isSelf)
                          _profileCircle(
                            background: backgroundPath,
                            avatar: avatarPath,
                            size: 40,
                            avatarRadius: 17,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
                      child:
                      const Icon(Icons.send, color: Colors.black, size: 22),
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