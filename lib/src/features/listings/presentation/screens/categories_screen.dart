import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_kart/src/core/utils/responsive.dart';
import 'package:campus_kart/src/features/listings/presentation/providers/listing_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'color': Color(0xFF2563EB), 'icon': Icons.apps_rounded},
    {
      'name': 'Electronics',
      'color': Color(0xFF8B5CF6),
      'icon': Icons.devices_rounded,
    },
    {
      'name': 'Books',
      'color': Color(0xFF3B82F6),
      'icon': Icons.menu_book_rounded,
    },
    {
      'name': 'Hostel Items',
      'color': Color(0xFF10B981),
      'icon': Icons.hotel_rounded,
    },
    {
      'name': 'Clothes',
      'color': Color(0xFFF97316),
      'icon': Icons.checkroom_rounded,
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
      'name': 'Others',
      'color': Color(0xFF64748B),
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Browse Categories',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: 820,
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.getGridColumnCount(context),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.15,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final color = cat['color'] as Color;
            final icon = cat['icon'] as IconData;
            final name = cat['name'] as String;

            return InkWell(
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = name;
                context.go('/home');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
