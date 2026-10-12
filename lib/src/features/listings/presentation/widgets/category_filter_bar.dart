import 'package:flutter/material.dart';

class CategoryFilterBar extends StatefulWidget {
  final ValueChanged<String?>? onCategorySelected;
  final String? initialSelected;

  const CategoryFilterBar({
    super.key,
    this.onCategorySelected,
    this.initialSelected,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  String? _selected;

  static const List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Books', 'icon': Icons.menu_book_rounded},
    {'label': 'Electronics', 'icon': Icons.devices_rounded},
    {'label': 'Clothes', 'icon': Icons.checkroom_rounded},
    {'label': 'Hostel Items', 'icon': Icons.hotel_rounded},
    {'label': 'Furniture', 'icon': Icons.chair_rounded},
    {'label': 'Sports & Games', 'icon': Icons.sports_basketball_rounded},
    {'label': 'Others', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final label = filter['label'] as String;
          final icon = filter['icon'] as IconData;
          final isSelected = _selected == label;

          return GestureDetector(
            onTap: () {
              setState(() => _selected = label);
              widget.onCategorySelected
                  ?.call(label == 'All' ? null : label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5C35EA)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5C35EA)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF6B7280),
                    ),
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
