import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  bool _showActive = true;

  static final List<Map<String, dynamic>> _activeListings = [
    {
      'title': 'MacBook Air M1',
      'price': '₹48,000',
      'time': '2 days ago',
      'image':
          'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=200&q=80',
      'status': 'Active',
    },
    {
      'title': 'Engineering Physics Book',
      'price': '₹250',
      'time': '5 hours ago',
      'image':
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=200&q=80',
      'status': 'Active',
    },
  ];

  static final List<Map<String, dynamic>> _soldListings = [
    {
      'title': 'Denim Jacket (M size)',
      'price': '₹800',
      'time': '5 days ago',
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=200&q=80',
      'status': 'Sold',
    },
    {
      'title': 'Casio Scientific Calculator',
      'price': '₹400',
      'time': '10 days ago',
      'image':
          'https://images.unsplash.com/photo-1564466809058-bf4114d55352?w=200&q=80',
      'status': 'Sold',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final listings = _showActive ? _activeListings : _soldListings;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Listings',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5C35EA),
        foregroundColor: Colors.white,
        onPressed: () => context.push('/create-listing'),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add New Listing',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // ── Toggle Chips ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                _ToggleChip(
                  label: 'Active',
                  selected: _showActive,
                  count: _activeListings.length,
                  onTap: () => setState(() => _showActive = true),
                ),
                const SizedBox(width: 12),
                _ToggleChip(
                  label: 'Sold',
                  selected: !_showActive,
                  count: _soldListings.length,
                  onTap: () => setState(() => _showActive = false),
                ),
              ],
            ),
          ),

          // ── Listing Cards ─────────────────────────────────────────
          Expanded(
            child: listings.isEmpty
                ? const Center(
                    child: Text(
                      'No listings here.',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: listings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = listings[index];
                      return _MyListingCard(item: item);
                    },
                  ),
          ),
        ],
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5C35EA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF5C35EA) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _MyListingCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _MyListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isSold = item['status'] == 'Sold';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image'] as String,
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
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
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
                    item['price'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF5C35EA),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSold
                    ? const Color(0xFF6B7280).withOpacity(0.12)
                    : const Color(0xFF22C55E).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item['status'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSold
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF22C55E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
