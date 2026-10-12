import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single message within a chat thread.
class MessageModel {
  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isAiSuggested,
  });

  final String messageId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  /// True when this message was generated/suggested by AI smart-reply.
  final bool isAiSuggested;

  // ── Firestore deserialization ─────────────────────────────────────────────

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      messageId: docId,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAiSuggested: map['isAiSuggested'] as bool? ?? false,
    );
  }

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // ── Firestore serialization ───────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isAiSuggested': isAiSuggested,
    };
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isAiSuggested,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isAiSuggested: isAiSuggested ?? this.isAiSuggested,
    );
  }

  @override
  String toString() =>
      'MessageModel(id: $messageId, sender: $senderId, text: $text)';
}
