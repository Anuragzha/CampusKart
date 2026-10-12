import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingCard extends StatefulWidget {
  final String title;
  final String price;
  final String location;
  final String time;
  final String imageUrl;
  final bool initiallyLiked;

  const ListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.time,
    required this.imageUrl,
    this.initiallyLiked = false,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  late bool _liked;

  @override
  void initState() {
    super.initState();
    _liked = widget.initiallyLiked;
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
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
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
                    widget.title,
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
                    widget.price,
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
                          widget.location,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF6B7280)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(
                        ' · ',
                        style:
                            TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Heart
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
