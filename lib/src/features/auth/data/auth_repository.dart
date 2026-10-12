import 'package:firebase_auth/firebase_auth.dart';

// ── Abstract contract ─────────────────────────────────────────────────────

/// Repository interface for all authentication operations.
abstract class AuthRepository {
  /// Stream that emits the current [User] or null when signed out.
  Stream<User?> get authStateChanges;

  /// Sign in with [email] and [password].
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Register a new user with [email], [password] and [displayName].
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Send a password-reset email.
  Future<void> sendPasswordResetEmail({required String email});

  /// Sign out the current user.
  Future<void> signOut();

  /// Currently signed-in user, or null.
  User? get currentUser;
}

// ── Firebase implementation ───────────────────────────────────────────────

/// Concrete implementation backed by [FirebaseAuth].
// TODO: Implement full FirebaseAuth integration
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    return credential.user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
