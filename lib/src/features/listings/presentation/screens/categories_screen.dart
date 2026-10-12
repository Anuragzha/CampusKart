import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'name': 'Books',
      'color': Color(0xFF3B82F6),
      'icon': Icons.menu_book_rounded,
    },
    {
      'name': 'Electronics',
      'color': Color(0xFF8B5CF6),
      'icon': Icons.devices_rounded,
    },
    {
      'name': 'Clothes',
      'color': Color(0xFFF97316),
      'icon': Icons.checkroom_rounded,
    },
    {
      'name': 'Hostel Items',
      'color': Color(0xFF22C55E),
      'icon': Icons.hotel_rounded,
    },
    {
      'name': 'Furniture',
      'color': Color(0xFFEF4444),
      'icon': Icons.chair_rounded,
    },
    {
      'name': 'Sports & Games',
      'color': Color(0xFF06B6D4),
      'icon': Icons.sports_basketball_rounded,
    },
    {
      'name': 'Beauty & Health',
      'color': Color(0xFFEC4899),
      'icon': Icons.spa_rounded,
    },
    {
      'name': 'Others',
      'color': Color(0xFF6B7280),
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final color = cat['color'] as Color;
          final icon = cat['icon'] as IconData;
          final name = cat['name'] as String;

          return GestureDetector(
            onTap: () => context.go('/home'),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF1A1A2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
