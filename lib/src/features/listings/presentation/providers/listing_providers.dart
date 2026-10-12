import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_kart/src/features/listings/data/listing_model.dart';
import 'package:campus_kart/src/features/listings/data/listing_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────

/// Provides the [ListingRepository] singleton (Firestore-backed).
final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return FirestoreListingRepository();
});

// ── State providers ───────────────────────────────────────────────────────

/// Currently selected category filter. 'All' means no filter.
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

/// Current search query string entered by the user.
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Stream providers ──────────────────────────────────────────────────────

/// Streams all active listings from Firestore, filtered by selected category.
/// Auto-disposed when no longer watched.
final listingsStreamProvider = StreamProvider.autoDispose<List<ListingModel>>((
  ref,
) {
  final repo = ref.watch(listingRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repo.getListings(category: category);
});

/// Streams listings for a specific seller [uid].
final sellerListingsStreamProvider = StreamProvider.autoDispose
    .family<List<ListingModel>, String>((ref, uid) {
      final repo = ref.watch(listingRepositoryProvider);
      return repo.getListingsBySeller(uid);
    });

// ── Derived / computed providers ──────────────────────────────────────────

/// Filters [listingsStreamProvider] by the current [searchQueryProvider].
/// Returns an empty list while data is loading.
final visibleListingsProvider = Provider.autoDispose<List<ListingModel>>((ref) {
  final listingsAsync = ref.watch(listingsStreamProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return listingsAsync.when(
    data: (listings) {
      if (query.isEmpty) return listings;
      return listings.where((l) {
        return l.title.toLowerCase().contains(query) ||
            l.description.toLowerCase().contains(query) ||
            l.category.toLowerCase().contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
