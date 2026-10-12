import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a chat thread between a buyer and seller about a listing.
class ChatModel {
  const ChatModel({
    required this.chatId,
    required this.buyerId,
    required this.sellerId,
    required this.listingId,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.unreadCounts,
  });

  final String chatId;
  final String buyerId;
  final String sellerId;
  final String listingId;
  final String lastMessage;
  final DateTime lastTimestamp;

  /// Map of uid → unread count. e.g. {'uid_buyer': 2, 'uid_seller': 0}
  final Map<String, int> unreadCounts;

  // ── Firestore deserialization ─────────────────────────────────────────────

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      chatId: docId,
      buyerId: map['buyerId'] as String? ?? '',
      sellerId: map['sellerId'] as String? ?? '',
      listingId: map['listingId'] as String? ?? '',
      lastMessage: map['lastMessage'] as String? ?? '',
      lastTimestamp:
          (map['lastTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCounts: Map<String, int>.from(
        (map['unreadCounts'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toInt()),
            ) ??
            {},
      ),
    );
  }

  factory ChatModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ChatModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // ── Firestore serialization ───────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'listingId': listingId,
      'lastMessage': lastMessage,
      'lastTimestamp': Timestamp.fromDate(lastTimestamp),
      'unreadCounts': unreadCounts,
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  ChatModel copyWith({
    String? chatId,
    String? buyerId,
    String? sellerId,
    String? listingId,
    String? lastMessage,
    DateTime? lastTimestamp,
    Map<String, int>? unreadCounts,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      listingId: listingId ?? this.listingId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  /// Returns the unread count for a specific [uid].
  int unreadCountFor(String uid) => unreadCounts[uid] ?? 0;

  /// Returns the other participant's UID given the current user's [uid].
  String otherUid(String uid) => uid == buyerId ? sellerId : buyerId;

  @override
  String toString() =>
      'ChatModel(chatId: $chatId, listingId: $listingId, lastMessage: $lastMessage)';
}
