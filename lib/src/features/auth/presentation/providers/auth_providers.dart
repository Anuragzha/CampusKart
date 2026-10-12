import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_kart/src/features/auth/data/auth_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────

/// Provides the [AuthRepository] singleton (Firebase-backed).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

// ── Auth state stream ─────────────────────────────────────────────────────

/// Emits the current Firebase [User] (or null) whenever auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ── Convenience derived providers ─────────────────────────────────────────

/// True when a user is signed in.
final isSignedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull != null;
});

/// The current user's UID, or null when signed out.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

/// The current user's display name, or null.
final currentUserDisplayNameProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.displayName;
});

/// The current user's email, or null.
final currentUserEmailProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.email;
});
