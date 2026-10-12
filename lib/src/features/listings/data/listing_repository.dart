import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_kart/src/features/listings/data/listing_model.dart';

// ── Abstract contract ─────────────────────────────────────────────────────

/// Repository interface for all listing CRUD operations.
abstract class ListingRepository {
  /// Stream of active listings, optionally filtered by [category].
  Stream<List<ListingModel>> getListings({String? category});

  /// Stream of listings posted by a specific seller [sellerId].
  Stream<List<ListingModel>> getListingsBySeller(String sellerId);

  /// Fetch a single listing by its Firestore document [id].
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

// ── Firestore implementation ──────────────────────────────────────────────

// TODO: Implement full Firestore integration
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
