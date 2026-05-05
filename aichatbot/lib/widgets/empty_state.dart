import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'robot_icon.dart';

class EmptyState extends StatefulWidget {
  final void Function(String) onQuickSend;
  const EmptyState({super.key, required this.onQuickSend});

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatCtrl,
            builder: (_, child) =>
                Transform.translate(offset: Offset(0, -12 * _floatCtrl.value), child: child),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.primary, colors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: colors.primaryGlow, blurRadius: 24, offset: const Offset(0, 8)),
                ],
              ),
              alignment: Alignment.center,
              child: const RobotIcon(size: 80),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              "I'm your AI assistant powered by advanced language models. How can I help you today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _quickAction('💻', 'Code Help', 'Get coding assistance', 'Help me write code'),
                _quickAction('📚', 'Learn', 'Understand topics', 'Explain a concept'),
                _quickAction('✍️', 'Write', 'Draft content', 'Write an email'),
                _quickAction('❓', 'Ask', 'Get answers', 'Answer questions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(String icon, String title, String desc, String prompt) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => widget.onQuickSend(prompt),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(fontSize: 12, height: 1.4, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
