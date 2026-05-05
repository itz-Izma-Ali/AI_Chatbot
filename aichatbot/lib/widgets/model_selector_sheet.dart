import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_model.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'pricing_sheet.dart';

void showModelSelectorSheet(BuildContext context) {
  final colors = context.colors;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scroll) => ModelSelectorSheet(scrollController: scroll),
    ),
  );
}

class ModelSelectorSheet extends StatelessWidget {
  final ScrollController scrollController;
  const ModelSelectorSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = context.watch<SettingsProvider>();
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose AI Model',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              itemCount: AIModel.all.length,
              itemBuilder: (_, i) {
                final m = AIModel.all[i];
                return _option(context, m, settings.selectedModelId == m.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(BuildContext context, AIModel model, bool selected) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? colors.primary.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _select(context, model),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? colors.primary : colors.border,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        model.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (model.badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [colors.primary, colors.primaryDark]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          model.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  model.description,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _select(BuildContext context, AIModel model) {
    final settings = context.read<SettingsProvider>();
    if (model.premium && settings.plan == UserPlan.free) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('🔒 Premium Model'),
          content: Text(
            '${model.name} requires Pro or Max subscription.\n\nUpgrade now to access the most powerful coding and reasoning models!',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Not now')),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                showPricingSheet(context);
              },
              child: const Text('See plans'),
            ),
          ],
        ),
      );
      return;
    }
    settings.selectModel(model.id);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (context.mounted) Navigator.pop(context);
    });
  }
}
