import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/constants/app_colors.dart';
import 'package:campus_kart/src/core/utils/responsive.dart';
import 'package:campus_kart/src/features/listings/data/listing_model.dart';
import 'package:campus_kart/src/features/listings/presentation/providers/listing_providers.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  const ListingDetailScreen({super.key, this.listingId});

  final String? listingId;

  @override
  ConsumerState<ListingDetailScreen> createState() =>
      _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = true;
  bool _isDetailsExpanded = true;
  bool _isReadMore = false;
  bool _isLiked = false;

  void _showBuyModal(BuildContext context, ListingModel item) {
    String selectedLocation = 'BUEST Central Library';
    String selectedPayment = 'Cash on Campus Meetup';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.handshake_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confirm Campus Deal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campus Meetup Location
                    const Text(
                      'Pickup Spot on Campus',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLocation,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'BUEST Central Library',
                              child: Text('BUEST Central Library (Foyer)'),
                            ),
                            DropdownMenuItem(
                              value: 'Campus Cafeteria',
                              child: Text('Campus Cafeteria (Ground Floor)'),
                            ),
                            DropdownMenuItem(
                              value: 'Hostel Block A Gate',
                              child: Text('Hostel Block A Gate'),
                            ),
                            DropdownMenuItem(
                              value: 'ECE / CSE Department Lobby',
                              child: Text('ECE / CSE Department Lobby'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedLocation = val);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Payment Method
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPayment,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'Cash on Campus Meetup',
                              child: Text('💵 Cash on Campus Meetup'),
                            ),
                            DropdownMenuItem(
                              value: 'UPI on Spot (GPay/PhonePe/Paytm)',
                              child: Text('📱 UPI on Spot (GPay/PhonePe)'),
                            ),
                            DropdownMenuItem(
                              value: 'Exchange + Cash Balance',
                              child: Text('🔄 Exchange + Cash Balance'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => selectedPayment = val);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price Summary
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Deal Amount:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '\$${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '🎉 Deal request sent to ${item.sellerName}! Opening chat...',
                              ),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                          context.push('/chat/${item.id}');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Send Deal Request',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(visibleListingsProvider);
    final item = listings.firstWhere(
      (l) => l.id == widget.listingId,
      orElse: () => listings.isNotEmpty
          ? listings.first
          : ListingModel(
              id: 'rtx-4080',
              sellerId: 'seller-1',
              title: 'PNY GeForce RTX™ 4080 - Graphics Card',
              description:
                  'NVIDIA® GeForce RTX® 40 Series GPUs are beyond fast for gamers and creators. They\'re powered by the ultra-efficient NVIDIA Ada Lovelace architecture which delivers a quantum leap in both performance and AI-powered graphics.',
              price: 1200.0,
              condition: ListingCondition.good,
              category: 'Electronics',
              photoUrls: [
                'https://images.unsplash.com/photo-1591488320449-011701bb6704?w=600&q=80',
              ],
              status: ListingStatus.active,
              location: 'Block B Tech Hostel',
              createdAt: DateTime.now(),
              specs: {
                'Graphics Coprocessor': 'NVIDIA GeForce RTX 4080',
                'Brand': 'PNY',
                'Ram': '16 GB',
                'GPU Clock Speed': '2205 MHz',
                'Video Output Interface': 'DisplayPort, HDMI 2.1',
              },
            ),
    );

    final isNew = item.condition == ListingCondition.newItem;
    final photos = item.photoUrls.isNotEmpty
        ? item.photoUrls
        : ['https://images.unsplash.com/photo-1591488320449-011701bb6704?w=600'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border_rounded,
              color: _isLiked ? Colors.red : const Color(0xFF0F172A),
            ),
            onPressed: () => setState(() => _isLiked = !_isLiked),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listing link copied to clipboard!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 820,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Title, Condition Badge, and Price ───────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isNew
                              ? AppColors.newBadgeBg
                              : AppColors.usedBadgeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isNew ? 'New' : 'Used',
                          style: TextStyle(
                            color: isNew
                                ? AppColors.newBadgeText
                                : AppColors.usedBadgeText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Image Gallery Carousel with Dots ────────────────────
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      itemCount: photos.length,
                      onPageChanged: (idx) =>
                          setState(() => _currentImageIndex = idx),
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Image.network(
                              photos[idx],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.image_outlined,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Dot indicators matching screenshot
                    if (photos.length > 1)
                      Positioned(
                        bottom: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            photos.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImageIndex == index ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index
                                    ? AppColors.primary
                                    : const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Accordion 1: Description ────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(
                        () => _isDescriptionExpanded = !_isDescriptionExpanded,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Icon(
                              _isDescriptionExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isDescriptionExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.description,
                              maxLines: _isReadMore ? null : 3,
                              overflow: _isReadMore
                                  ? null
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                height: 1.6,
                              ),
                            ),
                            if (item.description.length > 100) ...[
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isReadMore = !_isReadMore),
                                child: Text(
                                  _isReadMore ? 'Read less' : 'Read more',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Accordion 2: Details / Specs Grid ───────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(
                        () => _isDetailsExpanded = !_isDetailsExpanded,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Icon(
                              _isDetailsExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isDetailsExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final specs = item.specs.entries.toList();
                            if (specs.isEmpty) {
                              return Row(
                                children: [
                                  _buildSpecTile(
                                    'Campus Location',
                                    item.location,
                                  ),
                                  const SizedBox(width: 24),
                                  _buildSpecTile('Category', item.category),
                                ],
                              );
                            }

                            return Wrap(
                              spacing: 24,
                              runSpacing: 16,
                              children: specs.map((entry) {
                                return SizedBox(
                                  width: (constraints.maxWidth - 48) / 2,
                                  child: _buildSpecTile(entry.key, entry.value),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Seller Profile Card ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primarySurface,
                      child: Text(
                        item.sellerName.isNotEmpty
                            ? item.sellerName[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
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
                                item.sellerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: Color(0xFF2563EB),
                              ),
                            ],
                          ),
                          Text(
                            '${item.sellerHandle} • ${item.location}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Spacing for sticky bottom bar
            ],
          ),
        ),
      ),

      // ── Sticky Bottom Action Bar ──────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: SafeArea(
          child: ResponsiveContainer(
            maxWidth: 820,
            child: Row(
              children: [
                // Chat Outlined Button
                Expanded(
                  flex: 5,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/chat/${item.id}');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Chat',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Buy Now Filled Button
                Expanded(
                  flex: 6,
                  child: FilledButton(
                    onPressed: () => _showBuyModal(context, item),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white,
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

  Widget _buildSpecTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
