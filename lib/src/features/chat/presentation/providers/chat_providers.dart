import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_kart/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:campus_kart/src/features/chat/data/chat_model.dart';
import 'package:campus_kart/src/features/chat/data/chat_repository.dart';
import 'package:campus_kart/src/features/chat/data/message_model.dart';

// ── Repository provider ───────────────────────────────────────────────────

/// Provides the [ChatRepository] singleton (Firestore-backed).
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return FirestoreChatRepository();
});

// ── Stream providers ──────────────────────────────────────────────────────

/// Streams all chat threads for the currently signed-in user.
/// Returns an empty list when not signed in.
final inboxStreamProvider = StreamProvider.autoDispose<List<ChatModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const Stream.empty();

  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChats(uid);
});

/// Streams all messages for a specific chat, identified by [chatId].
final chatStreamProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatId) {
      final repo = ref.watch(chatRepositoryProvider);
      return repo.getMessages(chatId);
    });

// ── Derived providers ─────────────────────────────────────────────────────

/// Total unread message count across all chats for the current user.
final totalUnreadCountProvider = Provider.autoDispose<int>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return 0;

  final chatsAsync = ref.watch(inboxStreamProvider);
  return chatsAsync.when(
    data: (chats) =>
        chats.fold(0, (sum, chat) => sum + chat.unreadCountFor(uid)),
    loading: () => 0,
    error: (_, __) => 0,
  );
});
