import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/core/utils/responsive.dart';
import 'package:campus_kart/src/features/listings/data/listing_model.dart';
import 'package:campus_kart/src/features/listings/presentation/providers/listing_providers.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  bool _showActive = true;

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(
      sellerListingsStreamProvider('current-user'),
    );
    final repo = ref.read(listingRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My List',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => context.push('/create-listing'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/create-listing'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Post New Listing',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: 820,
        child: listingsAsync.when(
          data: (allListings) {
            final activeListings = allListings
                .where((item) => item.status == ListingStatus.active)
                .toList();
            final soldListings = allListings
                .where((item) => item.status == ListingStatus.sold)
                .toList();

            final currentList = _showActive ? activeListings : soldListings;

            return Column(
              children: [
                // ── Toggle Chips ──────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      _ToggleChip(
                        label: 'Active Listings',
                        selected: _showActive,
                        count: activeListings.length,
                        onTap: () => setState(() => _showActive = true),
                      ),
                      const SizedBox(width: 12),
                      _ToggleChip(
                        label: 'Sold',
                        selected: !_showActive,
                        count: soldListings.length,
                        onTap: () => setState(() => _showActive = false),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFE2E8F0)),

                // ── Listings List ─────────────────────────────────────
                Expanded(
                  child: currentList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showActive
                                    ? Icons.inventory_2_outlined
                                    : Icons.check_circle_outline_rounded,
                                size: 54,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _showActive
                                    ? 'You have no active listings yet'
                                    : 'No items marked as sold yet',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (_showActive)
                                FilledButton.icon(
                                  onPressed: () =>
                                      context.push('/create-listing'),
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Post Your First Listing'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: currentList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = currentList[index];
                            final isNew =
                                item.condition == ListingCondition.newItem;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item.photoUrls.isNotEmpty
                                          ? item.photoUrls.first
                                          : 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=200',
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 84,
                                                height: 84,
                                                color: const Color(0xFFF1F5F9),
                                                child: const Icon(
                                                  Icons.image_outlined,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Color(0xFF0F172A),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '\$${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isNew
                                                    ? AppColors.newBadgeBg
                                                    : AppColors.usedBadgeBg,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                isNew ? 'New' : 'Used',
                                                style: TextStyle(
                                                  color: isNew
                                                      ? AppColors.newBadgeText
                                                      : AppColors.usedBadgeText,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // Quick action buttons
                                        Row(
                                          children: [
                                            if (_showActive)
                                              InkWell(
                                                onTap: () async {
                                                  await repo.markAsSold(
                                                    item.id,
                                                  );
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Marked as Sold!',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .successSurface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Mark as Sold',
                                                    style: TextStyle(
                                                      color: Color(0xFF15803D),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () async {
                                                await repo.deleteListing(
                                                  item.id,
                                                );
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Listing deleted',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 18,
                                                  color: Color(0xFFEF4444),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF64748B),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF334155),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
