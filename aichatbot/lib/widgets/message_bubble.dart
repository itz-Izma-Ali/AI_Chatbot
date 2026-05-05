import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'robot_icon.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isUser = message.role == MessageRole.user;
    final time = _formatTime(message.timestamp);

    final avatar = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUser
              ? [colors.secondary, const Color(0xFF059669)]
              : [colors.primary, colors.primaryLight],
        ),
        boxShadow: [
          BoxShadow(
            color: isUser
                ? const Color(0x4D10B981)
                : colors.primaryGlow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: isUser
          ? const Text('U',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))
          : const Padding(
              padding: EdgeInsets.all(2),
              child: RobotIcon(size: 26),
            ),
    );

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isUser
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primary, colors.primaryDark],
              )
            : null,
        color: isUser ? null : colors.aiBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 18),
        ),
        boxShadow: isUser
            ? [BoxShadow(color: colors.primaryGlow, blurRadius: 8, offset: const Offset(0, 2))]
            : null,
      ),
      child: Text(
        message.text,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: isUser ? Colors.white : colors.textPrimary,
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        bubble,
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: Text(time, style: TextStyle(fontSize: 11, color: colors.textTertiary)),
        ),
        if (!isUser) _aiActions(context),
      ],
    );

    final children = <Widget>[
      avatar,
      const SizedBox(width: 10),
      Flexible(child: content),
    ];

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isUser ? children.reversed.toList() : children,
    );
  }

  Widget _aiActions(BuildContext context) {
    final colors = context.colors;
    final settings = context.read<SettingsProvider>();
    Widget btn(String emoji, String label, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 11, color: colors.textTertiary)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        children: [
          btn('📋', 'Copy', () async {
            await Clipboard.setData(ClipboardData(text: message.text));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            }
          }),
          btn('🔄', 'Regenerate', () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Regenerating with ${settings.selectedModel.name}...')),
            );
          }),
          btn('↗️', 'Share', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share options unavailable in demo')),
            );
          }),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour == 0 ? 12 : (t.hour > 12 ? t.hour - 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
