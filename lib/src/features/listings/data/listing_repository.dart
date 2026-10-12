import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_kart/src/features/listings/data/listing_model.dart';

// ── Abstract contract ─────────────────────────────────────────────────────

/// Repository interface for all listing CRUD operations.
abstract class ListingRepository {
  /// Stream of active listings, optionally filtered by [category].
  Stream<List<ListingModel>> getListings({String? category});

  /// Stream of listings posted by a specific seller [sellerId].
  Stream<List<ListingModel>> getListingsBySeller(String sellerId);

  /// Fetch a single listing by its document [id].
  Future<ListingModel?> getListingById(String id);

  /// Create a new listing. Returns the generated document ID.
  Future<String> createListing(ListingModel listing);

  /// Update an existing listing.
  Future<void> updateListing(ListingModel listing);

  /// Delete a listing by its [id].
  Future<void> deleteListing(String id);

  /// Mark a listing as sold.
  Future<void> markAsSold(String id);
}

// ── In-Memory Mock Repository (Reliable Offline / Fast UI Testing) ──────────

class MockListingRepository implements ListingRepository {
  MockListingRepository() {
    _initDefaultListings();
  }

  final List<ListingModel> _items = [];
  final StreamController<List<ListingModel>> _controller =
      StreamController<List<ListingModel>>.broadcast();

  void _notify() {
    _controller.add(List.unmodifiable(_items));
  }

  void _initDefaultListings() {
    _items.addAll([
      ListingModel(
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
          'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Block B Tech Hostel',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isFeatured: true,
        isNegotiable: true,
        sellerName: 'Jacob Jones',
        sellerHandle: '@jacob_gamer',
        specs: {
          'Graphics Coprocessor': 'NVIDIA GeForce RTX 4080',
          'Brand': 'PNY',
          'Ram': '16 GB',
          'GPU Clock Speed': '2205 MHz',
          'Video Output Interface': 'DisplayPort, HDMI 2.1',
        },
      ),
      ListingModel(
        id: 'razer-deathadder',
        sellerId: 'seller-2',
        title: 'Razer DeathAdder Essential Mouse',
        description:
            'Ergonomic wired gaming mouse with 6,400 DPI optical sensor. Proven durability with mechanical switches rated for up to 10 million clicks.',
        price: 19.0,
        condition: ListingCondition.good,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Main Library',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        isFeatured: false,
        isNegotiable: false,
        sellerName: 'Robert Fox',
        sellerHandle: '@robert_fox',
        specs: {
          'Brand': 'Razer',
          'DPI': '6400 DPI',
          'Connectivity': 'Wired USB',
        },
      ),
      ListingModel(
        id: 'razer-naga',
        sellerId: 'seller-3',
        title: 'Razer Naga X - Mouse',
        description:
            'MMO gaming mouse with 16 programmable buttons, 85g midweight ergonomic design, 2nd-gen Razer Optical Mouse Switch, and 18K DPI sensor.',
        price: 50.0,
        condition: ListingCondition.newItem,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Block A Hostel',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        isFeatured: true,
        isNegotiable: true,
        sellerName: 'Brooklyn Simmons',
        sellerHandle: '@brooklyn_s',
        specs: {
          'Brand': 'Razer',
          'Buttons': '16 Programmable',
          'Weight': '85g',
        },
      ),
      ListingModel(
        id: 'ipad-mini',
        sellerId: 'seller-4',
        title: 'Apple iPad mini, 256Gb',
        description:
            'Purple color, 256GB storage, Wi-Fi model. Excellent condition, always kept in folio case with paper-feel screen protector. Ideal for taking lecture notes and drawing.',
        price: 590.0,
        condition: ListingCondition.good,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Girls Hostel 2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isFeatured: true,
        isNegotiable: true,
        sellerName: 'Jenny Wilson',
        sellerHandle: '@jenny_w',
        specs: {
          'Brand': 'Apple',
          'Storage': '256 GB',
          'Display': '8.3-inch Liquid Retina',
        },
      ),
      ListingModel(
        id: 'razer-nari',
        sellerId: 'seller-5',
        title: 'Razer Nari Headphones',
        description:
            'Wireless 7.1 surround sound gaming headset with THX Spatial Audio, cooling gel-infused ear cushions, and 2.4GHz wireless audio. Barely used.',
        price: 89.0,
        condition: ListingCondition.newItem,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Cafeteria Block',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        isFeatured: false,
        isNegotiable: false,
        sellerName: 'Guy Hawkins',
        sellerHandle: '@guy_h',
        specs: {
          'Brand': 'Razer',
          'Audio': 'THX Spatial Audio',
          'Connectivity': '2.4GHz Wireless',
        },
      ),
      ListingModel(
        id: 'iphone-14-pro',
        sellerId: 'seller-6',
        title: 'iPhone 14 Pro - Deep Purple',
        description:
            '128GB Deep Purple iPhone 14 Pro with Dynamic Island, 48MP main camera, and Always-On display. 98% battery health, bill and box included.',
        price: 950.0,
        condition: ListingCondition.likeNew,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1678685888221-cda773a3dcdb?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'ECE Department',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isFeatured: true,
        isNegotiable: true,
        sellerName: 'Courtney Henry',
        sellerHandle: '@courtney_h',
        specs: {'Brand': 'Apple', 'Storage': '128 GB', 'Color': 'Deep Purple'},
      ),
      ListingModel(
        id: 'physics-book',
        sellerId: 'current-user',
        title: 'Engineering Physics Book (Halliday & Resnick)',
        description:
            'Principles of Physics by Halliday, Resnick, Walker (10th Edition). Essential for 1st-year BTech students. Highlighting only in chapter 3.',
        price: 25.0,
        condition: ListingCondition.good,
        category: 'Books',
        photoUrls: [
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'Central Library',
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        isFeatured: false,
        isNegotiable: false,
        sellerName: 'Anurag Jha',
        sellerHandle: '@anurag_buest',
        specs: {
          'Author': 'Halliday & Resnick',
          'Edition': '10th Edition',
          'Subject': 'Physics',
        },
      ),
      ListingModel(
        id: 'macbook-m1',
        sellerId: 'current-user',
        title: 'MacBook Air M1 (Silver, 8GB/256GB)',
        description:
            'MacBook Air M1 in excellent condition. Purchased for college coding, lightly used. Battery health is at 94%. Comes with original 30W charger and box.',
        price: 650.0,
        condition: ListingCondition.good,
        category: 'Electronics',
        photoUrls: [
          'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=600&q=80',
        ],
        status: ListingStatus.active,
        location: 'CSE Lab 4',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isFeatured: true,
        isNegotiable: true,
        sellerName: 'Anurag Jha',
        sellerHandle: '@anurag_buest',
        specs: {
          'Brand': 'Apple',
          'Processor': 'Apple M1',
          'RAM': '8 GB',
          'Storage': '256 GB SSD',
        },
      ),
    ]);
  }

  @override
  Stream<List<ListingModel>> getListings({String? category}) {
    List<ListingModel> filter(List<ListingModel> list) {
      return list.where((item) {
        if (item.status != ListingStatus.active) return false;
        if (category != null && category != 'All' && category.isNotEmpty) {
          return item.category.toLowerCase() == category.toLowerCase();
        }
        return true;
      }).toList();
    }

    return Stream.value(
      filter(_items),
    ).concatWith(_controller.stream.map((list) => filter(list)));
  }

  @override
  Stream<List<ListingModel>> getListingsBySeller(String sellerId) {
    List<ListingModel> filter(List<ListingModel> list) {
      return list.where((item) => item.sellerId == sellerId).toList();
    }

    return Stream.value(
      filter(_items),
    ).concatWith(_controller.stream.map((list) => filter(list)));
  }

  @override
  Future<ListingModel?> getListingById(String id) async {
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => _items.first,
    );
  }

  @override
  Future<String> createListing(ListingModel listing) async {
    final newId = 'listing-${DateTime.now().millisecondsSinceEpoch}';
    final saved = listing.copyWith(id: newId);
    _items.insert(0, saved);
    _notify();
    return newId;
  }

  @override
  Future<void> updateListing(ListingModel listing) async {
    final idx = _items.indexWhere((e) => e.id == listing.id);
    if (idx != -1) {
      _items[idx] = listing;
      _notify();
    }
  }

  @override
  Future<void> deleteListing(String id) async {
    _items.removeWhere((e) => e.id == id);
    _notify();
  }

  @override
  Future<void> markAsSold(String id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(status: ListingStatus.sold);
      _notify();
    }
  }
}

extension _StreamConcat<T> on Stream<T> {
  Stream<T> concatWith(Stream<T> other) async* {
    yield* this;
    yield* other;
  }
}

// ── Firestore implementation (Ready for Firebase Enablement) ──────────────

class FirestoreListingRepository implements ListingRepository {
  FirestoreListingRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _listingsRef =>
      _firestore.collection('listings');

  @override
  Stream<List<ListingModel>> getListings({String? category}) {
    Query<Map<String, dynamic>> query = _listingsRef
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map(
      (snap) => snap.docs
          .map((doc) => ListingModel.fromDocumentSnapshot(doc))
          .toList(),
    );
  }

  @override
  Stream<List<ListingModel>> getListingsBySeller(String sellerId) {
    return _listingsRef
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ListingModel.fromDocumentSnapshot(doc))
              .toList(),
        );
  }

  @override
  Future<ListingModel?> getListingById(String id) async {
    final doc = await _listingsRef.doc(id).get();
    if (!doc.exists) return null;
    return ListingModel.fromDocumentSnapshot(doc);
  }

  @override
  Future<String> createListing(ListingModel listing) async {
    final ref = await _listingsRef.add(listing.toMap());
    return ref.id;
  }

  @override
  Future<void> updateListing(ListingModel listing) async {
    await _listingsRef.doc(listing.id).update(listing.toMap());
  }

  @override
  Future<void> deleteListing(String id) async {
    await _listingsRef.doc(id).delete();
  }

  @override
  Future<void> markAsSold(String id) async {
    await _listingsRef.doc(id).update({'status': ListingStatus.sold.name});
  }
}
