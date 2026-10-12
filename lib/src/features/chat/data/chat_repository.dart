import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_kart/src/features/chat/data/chat_model.dart';
import 'package:campus_kart/src/features/chat/data/message_model.dart';

// ── Abstract contract ─────────────────────────────────────────────────────

/// Repository interface for all chat / messaging operations.
abstract class ChatRepository {
  /// Stream of all chat threads for the current user [uid].
  Stream<List<ChatModel>> getChats(String uid);

  /// Stream of messages for a specific [chatId], ordered by timestamp.
  Stream<List<MessageModel>> getMessages(String chatId);

  /// Send a [message] to the given [chatId].
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  });

  /// Mark all messages as read for [uid] in [chatId].
  Future<void> markAsRead({required String chatId, required String uid});

  /// Create a new chat thread. Returns the generated chatId.
  Future<String> createChat(ChatModel chat);
}

// ── Firestore implementation ──────────────────────────────────────────────

// TODO: Implement full Firestore integration
class FirestoreChatRepository implements ChatRepository {
  FirestoreChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _chatsRef =>
      _firestore.collection('chats');

  CollectionReference<Map<String, dynamic>> _messagesRef(String chatId) =>
      _chatsRef.doc(chatId).collection('messages');

  @override
  Stream<List<ChatModel>> getChats(String uid) {
    // Return chats where uid is either buyer or seller
    return _chatsRef
        .where('buyerId', isEqualTo: uid)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatModel.fromDocumentSnapshot(doc))
              .toList(),
        );
    // TODO: Merge seller chats (requires Union query or two separate streams)
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _messagesRef(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MessageModel.fromDocumentSnapshot(doc))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  }) async {
    final batch = _firestore.batch();

    // Add message document
    final msgRef = _messagesRef(chatId).doc();
    batch.set(msgRef, message.toMap());

    // Update last message on the chat thread
    final chatRef = _chatsRef.doc(chatId);
    batch.update(chatRef, {
      'lastMessage': message.text,
      'lastTimestamp': Timestamp.fromDate(message.timestamp),
    });

    await batch.commit();
  }

  @override
  Future<void> markAsRead({required String chatId, required String uid}) async {
    await _chatsRef.doc(chatId).update({'unreadCounts.$uid': 0});
  }

  @override
  Future<String> createChat(ChatModel chat) async {
    final ref = await _chatsRef.add(chat.toMap());
    return ref.id;
  }
}
