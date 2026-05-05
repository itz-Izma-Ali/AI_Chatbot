import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final List<Chat> _chats = [Chat.fresh(_genId())];
  String _activeChatId = '';
  bool _isTyping = false;

  ChatProvider() {
    _activeChatId = _chats.first.id;
  }

  List<Chat> get chats => List.unmodifiable(_chats);
  Chat get activeChat => _chats.firstWhere((c) => c.id == _activeChatId);
  String get activeChatId => _activeChatId;
  List<Message> get messages => activeChat.messages;
  bool get isTyping => _isTyping;
  bool get hasMessages => messages.isNotEmpty;

  static String _genId() => DateTime.now().microsecondsSinceEpoch.toString();

  void switchChat(String id) {
    if (_chats.any((c) => c.id == id)) {
      _activeChatId = id;
      notifyListeners();
    }
  }

  void newChat() {
    final c = Chat.fresh(_genId());
    _chats.insert(0, c);
    _activeChatId = c.id;
    notifyListeners();
  }

  bool deleteChat(String id) {
    if (_chats.length <= 1) return false;
    _chats.removeWhere((c) => c.id == id);
    if (_activeChatId == id) {
      _activeChatId = _chats.first.id;
    }
    notifyListeners();
    return true;
  }

  void clearAll() {
    _chats.clear();
    final c = Chat.fresh(_genId());
    _chats.add(c);
    _activeChatId = c.id;
    notifyListeners();
  }

  Future<void> sendMessage(String text, String currentModelName) async {
    if (text.trim().isEmpty) return;

    final chat = activeChat;
    chat.messages.add(Message(
      id: _genId(),
      role: MessageRole.user,
      text: text,
      timestamp: DateTime.now(),
    ));
    chat.timestamp = DateTime.now();

    if (chat.messages.length == 1) {
      chat.title = text.length > 30 ? '${text.substring(0, 30)}...' : text;
      chat.icon = _iconForMessage(text);
    }
    notifyListeners();

    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    _isTyping = false;
    chat.messages.add(Message(
      id: _genId(),
      role: MessageRole.ai,
      text: _generateResponse(currentModelName),
      timestamp: DateTime.now(),
    ));
    chat.timestamp = DateTime.now();
    notifyListeners();
  }

  String _generateResponse(String modelName) {
    var response = "Hello! I'm powered by $modelName. ";
    if (modelName.contains('GPT-5.5')) {
      response +=
          "I excel at agentic workflows, multimodal tasks, and autonomous completion. I scored 82.7% on Terminal-Bench 2.0 and have advanced long-term memory capabilities. How can I assist you?";
    } else if (modelName.contains('Claude Opus 4.7')) {
      response +=
          "I'm the strongest coding model with 87.6% on SWE-bench Verified. I excel at complex multi-file coding, PR review, and long-context technical work with 200K-1M token context. What would you like to build?";
    } else if (modelName.contains('Gemini 3.1')) {
      response +=
          "I lead scientific reasoning with 94.3% on GPQA Diamond and offer 1M token context for processing entire codebases. I integrate seamlessly with Google Workspace. What can I help you research?";
    } else if (modelName.contains('Grok')) {
      response +=
          "I have real-time access to X/Twitter data, video input capabilities, and excel at live research and breaking news analysis. What's happening now that you'd like to know about?";
    } else if (modelName.contains('DeepSeek')) {
      response +=
          "I'm the most cost-effective frontier model at \$0.14/M tokens while maintaining strong performance. Great for high-volume tasks without breaking the budget. What can I help optimize?";
    } else {
      response +=
          "I'm an advanced open-weight model from Chinese labs, scoring 58.4% on SWE-bench. I offer MIT license flexibility for commercial use. What would you like to explore?";
    }
    return response;
  }

  String _iconForMessage(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('code') || lower.contains('program') || lower.contains('function')) return '💻';
    if (lower.contains('write') || lower.contains('email') || lower.contains('letter')) return '✍️';
    if (lower.contains('learn') || lower.contains('explain') || lower.contains('what is')) return '📚';
    if (lower.contains('image') || lower.contains('picture') || lower.contains('photo')) return '🖼️';
    if (lower.contains('translate')) return '🌐';
    if (lower.contains('math') || lower.contains('calculate')) return '🔢';
    return '💬';
  }
}
