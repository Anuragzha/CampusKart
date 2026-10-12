import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';

class _ChatThread {
  final String id;
  final String name;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;

  const _ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
  });
}

const List<_ChatThread> _dummyThreads = [
  _ChatThread(
    id: 'thread-1',
    name: 'Priya Sharma',
    lastMessage: 'Is the calculator still available?',
    timestamp: '10:32 AM',
    unreadCount: 2,
  ),
  _ChatThread(
    id: 'thread-2',
    name: 'Rahul Verma',
    lastMessage: 'Sure, I can meet at the library.',
    timestamp: 'Yesterday',
    unreadCount: 0,
  ),
  _ChatThread(
    id: 'thread-3',
    name: 'Sneha Patel',
    lastMessage: 'Can you lower the price a bit?',
    timestamp: 'Mon',
    unreadCount: 5,
  ),
  _ChatThread(
    id: 'thread-4',
    name: 'Arjun Mehta',
    lastMessage: 'Thanks! Got the book.',
    timestamp: 'Sun',
    unreadCount: 0,
  ),
];

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _dummyThreads.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 80,
          endIndent: 16,
          color: AppColors.background,
        ),
        itemBuilder: (context, index) {
          final thread = _dummyThreads[index];
          final initial = thread.name.isNotEmpty
              ? thread.name[0].toUpperCase()
              : '?';

          return Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => context.push('/chat/dummy-id'),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primarySurface,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                thread.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                thread.timestamp,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  thread.lastMessage,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (thread.unreadCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${thread.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
