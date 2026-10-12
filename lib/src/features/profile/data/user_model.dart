import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a CampusKart user profile stored in Firestore.
class UserModel {
  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.campusLocation,
    required this.listingsCount,
    required this.joinedAt,
  });

  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String campusLocation;
  final int listingsCount;
  final DateTime joinedAt;

  // ── Firestore deserialization ─────────────────────────────────────────────

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      campusLocation: map['campusLocation'] as String? ?? '',
      listingsCount: (map['listingsCount'] as num?)?.toInt() ?? 0,
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // ── Firestore serialization ───────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'campusLocation': campusLocation,
      'listingsCount': listingsCount,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? campusLocation,
    int? listingsCount,
    DateTime? joinedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      campusLocation: campusLocation ?? this.campusLocation,
      listingsCount: listingsCount ?? this.listingsCount,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, displayName: $displayName, email: $email)';
}
