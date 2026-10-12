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
        return 'Used';
      case ListingCondition.fair:
        return 'Fair';
    }
  }

  static ListingCondition fromString(String value) {
    return ListingCondition.values.firstWhere(
      (e) => e.name == value || e.label.toLowerCase() == value.toLowerCase(),
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

/// Represents a marketplace listing.
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
    this.isFeatured = false,
    this.isNegotiable = true,
    this.sellerName = 'Student Seller',
    this.sellerHandle = '@campus_user',
    this.specs = const {},
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
  final bool isFeatured;
  final bool isNegotiable;
  final String sellerName;
  final String sellerHandle;
  final Map<String, String> specs;

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
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] is DateTime
                ? map['createdAt'] as DateTime
                : DateTime.now()),
      isFeatured: map['isFeatured'] as bool? ?? false,
      isNegotiable: map['isNegotiable'] as bool? ?? true,
      sellerName: map['sellerName'] as String? ?? 'Student Seller',
      sellerHandle: map['sellerHandle'] as String? ?? '@campus_user',
      specs: Map<String, String>.from(map['specs'] as Map? ?? {}),
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
      'isFeatured': isFeatured,
      'isNegotiable': isNegotiable,
      'sellerName': sellerName,
      'sellerHandle': sellerHandle,
      'specs': specs,
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
    bool? isFeatured,
    bool? isNegotiable,
    String? sellerName,
    String? sellerHandle,
    Map<String, String>? specs,
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
      isFeatured: isFeatured ?? this.isFeatured,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      sellerName: sellerName ?? this.sellerName,
      sellerHandle: sellerHandle ?? this.sellerHandle,
      specs: specs ?? this.specs,
    );
  }

  @override
  String toString() =>
      'ListingModel(id: $id, title: $title, price: $price, status: ${status.name})';
}
