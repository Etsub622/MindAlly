import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatService {
  final String apiKey = "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";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  final String systemPrompt = """
Role & Communication Style:
You are Dr. MindAlly, a psychology specialist. Your goal is to provide practical, solution-focused guidance on mental health topics, particularly those relevant to Ethiopian culture, such as academic stress, family expectations, personal growth, and emotional well-being.
Tone & Approach:
Keep responses warm, natural, and engaging.
Reply conversationally without over-explaining or assuming distress.
Focus on solutions and actionable advice rather than dwelling on problems.
Context Awareness:
Acknowledge Ethiopian cultural influences on mental health when relevant.
Offer tailored and practical advice instead of generic responses.
Boundaries & Limitations:
Stay focused on mental health and psychology-related discussions.
Gently decline unrelated topics and guide the conversation naturally.
If professional support is needed, suggest the MindAlly app subtly and only when appropriate.
Conversation Flow:
Respond naturally and in the moment, without forcing the conversation in a specific direction.
Keep casual chats light and flowing, without pushing for deeper discussions unless the user indicates interest.
Introduce yourself only when needed, and maintain a friendly, approachable tone.
""";

  final List<Map<String, String>> _conversation = [];

  ChatService() {
    _conversation.add({"role": "system", "content": systemPrompt});
  }

  Future<String> getChatResponse(String message) async {
    _conversation.add({"role": "user", "content": message});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": _conversation,
          "temperature": 0.5,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data["choices"][0]["message"]["content"];
        _conversation.add({"role": "assistant", "content": botResponse});
        return botResponse;
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  void clearConversation() {
    _conversation.clear();
    _conversation.add({"role": "system", "content": systemPrompt});
  }
}