enum MessageRole { user, ai }

class Message {
  final String id;
  final MessageRole role;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        role: MessageRole.values.firstWhere((r) => r.name == json['role']),
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
