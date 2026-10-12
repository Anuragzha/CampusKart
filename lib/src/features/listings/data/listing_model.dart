import 'package:cloud_firestore/cloud_firestore.dart';

// ── Enums ─────────────────────────────────────────────────────────────────

enum ListingCondition {
  newItem,
  likeNew,
  good,
  fair;

  String get label {
    switch (this) {
      case ListingCondition.newItem:
        return 'New';
      case ListingCondition.likeNew:
        return 'Like New';
      case ListingCondition.good:
        return 'Good';
      case ListingCondition.fair:
        return 'Fair';
    }
  }

  static ListingCondition fromString(String value) {
    return ListingCondition.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ListingCondition.good,
    );
  }
}

enum ListingStatus {
  active,
  sold;

  static ListingStatus fromString(String value) {
    return ListingStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ListingStatus.active,
    );
  }
}

// ── Model ─────────────────────────────────────────────────────────────────

/// Represents a single marketplace listing stored in Firestore.
class ListingModel {
  const ListingModel({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.category,
    required this.photoUrls,
    required this.status,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final ListingCondition condition;
  final String category;
  final List<String> photoUrls;
  final ListingStatus status;
  final String location;
  final DateTime createdAt;

  // ── Firestore deserialization ─────────────────────────────────────────────

  factory ListingModel.fromMap(Map<String, dynamic> map, String docId) {
    return ListingModel(
      id: docId,
      sellerId: map['sellerId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      condition: ListingCondition.fromString(
        map['condition'] as String? ?? 'good',
      ),
      category: map['category'] as String? ?? '',
      photoUrls: List<String>.from(map['photoUrls'] as List? ?? []),
      status: ListingStatus.fromString(map['status'] as String? ?? 'active'),
      location: map['location'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ListingModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ListingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // ── Firestore serialization ───────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'condition': condition.name,
      'category': category,
      'photoUrls': photoUrls,
      'status': status.name,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  ListingModel copyWith({
    String? id,
    String? sellerId,
    String? title,
    String? description,
    double? price,
    ListingCondition? condition,
    String? category,
    List<String>? photoUrls,
    ListingStatus? status,
    String? location,
    DateTime? createdAt,
  }) {
    return ListingModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      category: category ?? this.category,
      photoUrls: photoUrls ?? this.photoUrls,
      status: status ?? this.status,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ListingModel(id: $id, title: $title, price: $price, status: ${status.name})';
}
