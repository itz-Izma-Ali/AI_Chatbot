import 'message.dart';

class Chat {
  final String id;
  String title;
  String icon;
  List<Message> messages;
  DateTime timestamp;

  Chat({
    required this.id,
    required this.title,
    required this.icon,
    required this.messages,
    required this.timestamp,
  });

  factory Chat.fresh(String id) => Chat(
        id: id,
        title: 'New Chat',
        icon: '💬',
        messages: [],
        timestamp: DateTime.now(),
      );
}
