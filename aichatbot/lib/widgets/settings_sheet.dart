import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_model.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'pricing_sheet.dart';

void showSettingsSheet(BuildContext context) {
  final colors = context.colors;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const SettingsSheet(),
  );
}

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = context.watch<SettingsProvider>();
    final chatProv = context.read<ChatProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '⚙️ Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.textPrimary),
            ),
            const SizedBox(height: 24),
            Text(
              '💳 Subscription: ${settings.plan.name.toUpperCase()}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                showPricingSheet(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(settings.plan == UserPlan.free ? '⭐ Upgrade to Pro' : '📊 Manage Plan'),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('🌙 Dark Mode', style: TextStyle(color: colors.textPrimary)),
              value: settings.isDark,
              onChanged: (_) => settings.toggleDarkMode(),
              activeColor: colors.primary,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('🔊 Voice Input Enabled', style: TextStyle(color: colors.textPrimary)),
              value: settings.voiceEnabled,
              onChanged: settings.setVoiceEnabled,
              activeColor: colors.primary,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('💾 Chat history exported (demo)')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  foregroundColor: colors.textPrimary,
                ),
                child: const Text('📥 Export Chat History'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _confirmClear(context, chatProv),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  foregroundColor: const Color(0xFFEF4444),
                ),
                child: const Text('🗑️ Clear All Chats'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    'AI Chat v2.1.0 (May 2026)',
                    style: TextStyle(fontSize: 12, color: colors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Powered by latest frontier models',
                    style: TextStyle(fontSize: 12, color: colors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, ChatProvider chatProv) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all chats?'),
        content: const Text('This will delete all conversation history. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (ok == true) {
      chatProv.clearAll();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ All chats cleared')),
        );
      }
    }
  }
}
