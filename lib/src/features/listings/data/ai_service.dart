import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiListingEnhancement {
  final String enhancedTitle;
  final String generatedDescription;
  final List<String> suggestedTags;

  const AiListingEnhancement({
    required this.enhancedTitle,
    required this.generatedDescription,
    required this.suggestedTags,
  });

  factory AiListingEnhancement.fromJson(Map<String, dynamic> json) {
    return AiListingEnhancement(
      enhancedTitle: json['enhanced_title'] as String? ?? '',
      generatedDescription: json['generated_description'] as String? ?? '',
      suggestedTags:
          (json['suggested_tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class AiService {
  /// Paste your live deployed Render URL here (e.g. 'https://campuskart-ai.onrender.com')
  /// When null/empty, automatically falls back to local server (localhost / 10.0.2.2).
  static const String? liveBackendUrl = null;

  static String get baseUrl {
    if (liveBackendUrl != null && liveBackendUrl!.trim().isNotEmpty) {
      return liveBackendUrl!.trim();
    }
    if (kIsWeb) return 'http://localhost:8000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  /// Calls FastAPI /api/v1/ai/generate-description (Groq LPU Llama-3)
  static Future<AiListingEnhancement> enhanceListing({
    required String title,
    required String category,
    required String condition,
    required double price,
    String? notes,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/v1/ai/generate-description'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'item_title': title.trim().isEmpty ? 'Campus Item' : title.trim(),
              'category': category.isEmpty ? 'General' : category,
              'condition': condition.isEmpty ? 'Good' : condition,
              'price': price <= 0 ? 100.0 : price,
              'additional_notes': notes,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AiListingEnhancement.fromJson(data);
      }
    } catch (e) {
      debugPrint(
        'FastAPI backend not reached ($e), using local AI model fallback',
      );
    }

    // Graceful offline fallback if local FastAPI server is not started yet
    return AiListingEnhancement(
      enhancedTitle: title.isNotEmpty
          ? '$title (Student Verified • Good Condition)'
          : 'Campus Item',
      generatedDescription:
          'Original and verified campus item in $condition condition. '
          'Ideal for BUEST students. Asking price ₹${price.toStringAsFixed(0)} (open to fair student negotiation). '
          'Can meet in person at the campus library or cafeteria for inspection.',
      suggestedTags: [category, condition, 'BUESTVerified'],
    );
  }

  /// Calls FastAPI /api/v1/ai/smart-replies (Groq LPU Llama-3)
  static Future<List<String>> getSmartReplies({
    required String lastMessage,
    required String itemTitle,
    required double itemPrice,
    bool isSeller = true,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/v1/ai/smart-replies'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'last_message': lastMessage.isEmpty
                  ? 'Is this available?'
                  : lastMessage,
              'item_title': itemTitle,
              'item_price': itemPrice <= 0 ? 500.0 : itemPrice,
              'is_seller': isSeller,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final suggestions = (data['suggestions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList();
        if (suggestions != null && suggestions.isNotEmpty) {
          return suggestions;
        }
      }
    } catch (e) {
      debugPrint(
        'FastAPI backend not reached ($e), using local fallback replies',
      );
    }

    if (isSeller) {
      return [
        'Yes, it is available for ₹${itemPrice.toStringAsFixed(0)}',
        'Can meet near the Library cafeteria',
        'Price is final, sorry!',
      ];
    } else {
      return [
        'Can you do ₹${(itemPrice * 0.9).toStringAsFixed(0)}?',
        'Is this still available?',
        'Where can we meet on campus?',
      ];
    }
  }
}
