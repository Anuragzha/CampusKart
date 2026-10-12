import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/core/utils/responsive.dart';

enum _ChatRole { buying, selling }

class _ChatThread {
  final String id;
  final String name;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final _ChatRole role;
  final bool isRead;

  const _ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.role,
    this.isRead = false,
  });
}

const List<_ChatThread> _mockThreads = [
  _ChatThread(
    id: 'thread-jacob',
    name: 'Jacob Jones',
    lastMessage: 'Can you please tell me the final price?',
    timestamp: '9:36 PM',
    unreadCount: 0,
    isRead: true,
    role: _ChatRole.buying,
  ),
  _ChatThread(
    id: 'thread-robert',
    name: 'Robert Fox',
    lastMessage: 'Thank you for your help.',
    timestamp: '11:45 AM',
    unreadCount: 2,
    role: _ChatRole.selling,
  ),
  _ChatThread(
    id: 'thread-brooklyn',
    name: 'Brooklyn Simmons',
    lastMessage: 'Hello, I\'m interested in purchasing this...',
    timestamp: '10:15 AM',
    unreadCount: 1,
    role: _ChatRole.selling,
  ),
  _ChatThread(
    id: 'thread-guy',
    name: 'Guy Hawkins',
    lastMessage: 'That sounds good. How do I make the...',
    timestamp: 'Yesterday',
    unreadCount: 0,
    isRead: true,
    role: _ChatRole.buying,
  ),
  _ChatThread(
    id: 'thread-courtney',
    name: 'Courtney Henry',
    lastMessage: 'Was great dealing with you. Thanks!',
    timestamp: '2d ago',
    unreadCount: 0,
    isRead: true,
    role: _ChatRole.selling,
  ),
  _ChatThread(
    id: 'thread-jenny',
    name: 'Jenny Wilson',
    lastMessage: 'Let\'s meet at BUEST Central Library.',
    timestamp: '3d ago',
    unreadCount: 0,
    isRead: true,
    role: _ChatRole.buying,
  ),
];

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String _selectedTab = 'All'; // 'All', 'Buying', 'Selling'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredThreads = _mockThreads.where((thread) {
      if (_selectedTab == 'Buying' && thread.role != _ChatRole.buying) {
        return false;
      }
      if (_selectedTab == 'Selling' && thread.role != _ChatRole.selling) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return thread.name.toLowerCase().contains(query) ||
            thread.lastMessage.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF0F172A),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 720,
        child: Column(
          children: [
            // ── Search Chat Box matching mockup ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search Chat Here',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter Tabs: All, Buying, Selling ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildFilterTab('All'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Buying'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Selling'),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // ── Chat Threads List ───────────────────────────────────────
            Expanded(
              child: filteredThreads.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No conversations found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredThreads.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 72,
                        endIndent: 16,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (context, index) {
                        final thread = filteredThreads[index];
                        final isBuying = thread.role == _ChatRole.buying;

                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () => context.push('/chat/${thread.id}'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // User Avatar
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(0xFFEFF6FF),
                                    child: Text(
                                      thread.name.isNotEmpty
                                          ? thread.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Name, Badge, Message Snippet
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              thread.name,
                                              style: const TextStyle(
                                                color: Color(0xFF0F172A),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),

                                            // Role Tag: Buying / Selling
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isBuying
                                                    ? AppColors.buyingBadgeBg
                                                    : AppColors.sellingBadgeBg,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                isBuying ? 'Buying' : 'Selling',
                                                style: TextStyle(
                                                  color: isBuying
                                                      ? AppColors
                                                            .buyingBadgeText
                                                      : AppColors
                                                            .sellingBadgeText,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          thread.lastMessage,
                                          style: const TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Timestamp & Read Status / Unread Count
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        thread.timestamp,
                                        style: const TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      if (thread.unreadCount > 0)
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${thread.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      else if (thread.isRead)
                                        const Icon(
                                          Icons.done_all_rounded,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = _selectedTab == label;

    return InkWell(
      onTap: () => setState(() => _selectedTab = label),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
