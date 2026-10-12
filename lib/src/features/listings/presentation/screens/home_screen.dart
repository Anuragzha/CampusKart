import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Map<String, dynamic>> _listings = [
    {
      'title': 'MacBook Air M1',
      'price': '₹48,000',
      'location': 'Block A Hostel',
      'time': '2 days ago',
      'image':
          'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=200&q=80',
      'liked': false,
    },
    {
      'title': 'Engineering Physics Book',
      'price': '₹250',
      'location': 'Main Library',
      'time': '5 hours ago',
      'image':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=200&q=80',
      'liked': true,
    },
    {
      'title': 'Denim Jacket (M size)',
      'price': '₹800',
      'location': 'Girls Hostel',
      'time': '1 day ago',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=200&q=80',
      'liked': false,
    },
  ];

  static final List<Map<String, dynamic>> _categories = [
    {'label': 'Books', 'icon': Icons.menu_book, 'color': Color(0xFF3B82F6)},
    {'label': 'Electronics', 'icon': Icons.devices, 'color': Color(0xFF8B5CF6)},
    {'label': 'Clothes', 'icon': Icons.checkroom, 'color': Color(0xFFF97316)},
    {
      'label': 'Hostel Items',
      'icon': Icons.hotel,
      'color': Color(0xFF22C55E)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── AppBar ──────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C35EA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'CampusKart',
                    style: TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF1A1A2E)),
                  onPressed: () {},
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search Bar ───────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for books, electronics...',
                          hintStyle: const TextStyle(
                              color: Color(0xFF6B7280), fontSize: 14),
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFF6B7280)),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Purple Gradient Banner ───────────────────────
                    Container(
                      width: double.infinity,
                      height: 130,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5C35EA), Color(0xFF7C5CFC)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Good Deals\nBetter Community',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Buy. Sell. Exchange.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Categories ───────────────────────────────────
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // ── Category Chips (horizontal scroll) ──────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: cat['color'] as Color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['label'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── Popular Listings heading ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Popular Listings',
                        style: TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to full listings
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF5C35EA),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Listing Cards ───────────────────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _listings[index];
                  return _ListingCard(item: item);
                },
                childCount: _listings.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const _ListingCard({required this.item});

  @override
  State<_ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<_ListingCard> {
  late bool _liked;

  @override
  void initState() {
    super.initState();
    _liked = widget.item['liked'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/listing-detail'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.item['image'] as String,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFF1F3F7),
                  child: const Icon(Icons.image_outlined,
                      color: Color(0xFF6B7280)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item['price'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF5C35EA),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Color(0xFF6B7280)),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          widget.item['location'] as String,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(' · ',
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280))),
                      Text(
                        widget.item['time'] as String,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Heart button
            GestureDetector(
              onTap: () => setState(() => _liked = !_liked),
              child: Icon(
                _liked ? Icons.favorite : Icons.favorite_border,
                color: _liked ? Colors.red : const Color(0xFF6B7280),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
