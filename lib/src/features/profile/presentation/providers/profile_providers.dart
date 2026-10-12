import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_kart/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:campus_kart/src/features/profile/data/user_model.dart';
import 'package:campus_kart/src/features/profile/data/user_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────

/// Provides the [UserRepository] singleton (Firestore-backed).
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirestoreUserRepository();
});

// ── Profile stream providers ──────────────────────────────────────────────

/// Streams the profile of a user by [uid].
final userProfileStreamProvider = StreamProvider.autoDispose
    .family<UserModel?, String>((ref, uid) {
      final repo = ref.watch(userRepositoryProvider);
      return repo.streamUser(uid);
    });

/// Streams the current signed-in user's own profile.
/// Returns null stream when not signed in.
final currentUserProfileProvider = StreamProvider.autoDispose<UserModel?>((
  ref,
) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const Stream.empty();

  final repo = ref.watch(userRepositoryProvider);
  return repo.streamUser(uid);
});
