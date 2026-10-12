import 'package:flutter/material.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/features/listings/data/ai_service.dart';

class SmartReplyChips extends StatefulWidget {
  const SmartReplyChips({
    super.key,
    required this.itemTitle,
    required this.itemPrice,
    required this.onReplySelected,
    this.isSeller = false,
  });

  final String itemTitle;
  final double itemPrice;
  final bool isSeller;
  final void Function(String reply) onReplySelected;

  @override
  State<SmartReplyChips> createState() => _SmartReplyChipsState();
}

class _SmartReplyChipsState extends State<SmartReplyChips> {
  List<String> _replies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  Future<void> _loadReplies() async {
    final replies = await AiService.getSmartReplies(
      lastMessage: 'Is this available?',
      itemTitle: widget.itemTitle,
      itemPrice: widget.itemPrice,
      isSeller: widget.isSeller,
    );
    if (mounted) {
      setState(() {
        _replies = replies;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(height: 38);
    }

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _replies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reply = _replies[index];
          return ActionChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  reply,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.primarySurface,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () => widget.onReplySelected(reply),
          );
        },
      ),
    );
  }
}
