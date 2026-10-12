import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_kart/src/features/profile/data/user_model.dart';

// ── Abstract contract ─────────────────────────────────────────────────────

/// Repository interface for user profile operations.
abstract class UserRepository {
  /// Fetch a user profile by [uid].
  Future<UserModel?> getUserById(String uid);

  /// Stream a user profile for real-time updates.
  Stream<UserModel?> streamUser(String uid);

  /// Create or overwrite a user profile document.
  Future<void> setUser(UserModel user);

  /// Update specific fields on a user profile.
  Future<void> updateUser(String uid, Map<String, dynamic> fields);

  /// Increment the [listingsCount] for a user.
  Future<void> incrementListingsCount(String uid);
}

// ── Firestore implementation ──────────────────────────────────────────────

// TODO: Implement full Firestore integration
class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  @override
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromDocumentSnapshot(doc);
  }

  @override
  Stream<UserModel?> streamUser(String uid) {
    return _usersRef
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromDocumentSnapshot(doc) : null);
  }

  @override
  Future<void> setUser(UserModel user) async {
    await _usersRef.doc(user.uid).set(user.toMap());
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> fields) async {
    await _usersRef.doc(uid).update(fields);
  }

  @override
  Future<void> incrementListingsCount(String uid) async {
    await _usersRef.doc(uid).update({'listingsCount': FieldValue.increment(1)});
  }
}
