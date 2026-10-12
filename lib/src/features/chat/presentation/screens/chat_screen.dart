import 'package:flutter/material.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/features/chat/presentation/widgets/smart_reply_chips.dart';

enum _MessageType { text, image }

class _ChatMessage {
  final String text;
  final bool isSent;
  final String timestamp;
  final _MessageType type;
  final String? imageUrl;

  const _ChatMessage({
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.type = _MessageType.text,
    this.imageUrl,
  });
}

const List<_ChatMessage> _dummyMessages = [
  _ChatMessage(
    text: 'Hi! Is the scientific calculator still available?',
    isSent: false,
    timestamp: '10:25 AM',
  ),
  _ChatMessage(
    text: 'Yes, it is! Casio fx-991EX, barely used.',
    isSent: true,
    timestamp: '10:27 AM',
  ),
  _ChatMessage(
    text: 'Great! Can I see a photo of it?',
    isSent: false,
    timestamp: '10:28 AM',
  ),
  _ChatMessage(
    text: '',
    isSent: true,
    timestamp: '10:29 AM',
    type: _MessageType.image,
    imageUrl: 'https://picsum.photos/seed/calc/400/300',
  ),
  _ChatMessage(
    text: 'Looks good! What\'s the best price you can do?',
    isSent: false,
    timestamp: '10:31 AM',
  ),
  _ChatMessage(
    text: 'I can do ₹600. It\'s listed at ₹700 but for quick sale.',
    isSent: true,
    timestamp: '10:32 AM',
  ),
  _ChatMessage(
    text: 'Deal! Can we meet at the library tomorrow?',
    isSent: false,
    timestamp: '10:33 AM',
  ),
];

class ChatScreen extends StatefulWidget {
  final String? chatId;

  const ChatScreen({super.key, this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String peerName = 'Priya Sharma';
    final String peerInitial = peerName[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Row(
          children: [
            const SizedBox(width: 4),
            BackButton(
              color: AppColors.textPrimary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
        leadingWidth: 40,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                peerInitial,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  peerName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Color(0xFF22C55E), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _dummyMessages.length,
              itemBuilder: (context, index) {
                final message = _dummyMessages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          SmartReplyChips(
            itemTitle: 'MacBook Air M1',
            itemPrice: 48000,
            onReplySelected: (reply) {
              _messageController.text = reply;
            },
          ),
          const SizedBox(height: 4),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isSent = message.isSent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSent) const SizedBox(width: 0),
          Column(
            crossAxisAlignment: isSent
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.type == _MessageType.image)
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: isSent
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(0),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(12),
                          ),
                    color: Colors.grey.shade200,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    message.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSent ? AppColors.primary : Colors.white,
                    borderRadius: isSent
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(0),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(12),
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isSent ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                message.timestamp,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              icon: const Icon(
                Icons.attach_file_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                final text = _messageController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _dummyMessages.add(
                      _ChatMessage(
                        text: text,
                        isSent: true,
                        timestamp: 'Just now',
                        type: _MessageType.text,
                      ),
                    );
                  });
                  _messageController.clear();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
