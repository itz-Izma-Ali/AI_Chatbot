import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_model.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';

void showPricingSheet(BuildContext context) {
  final colors = context.colors;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scroll) => PricingSheet(scrollController: scroll),
    ),
  );
}

class PricingSheet extends StatelessWidget {
  final ScrollController scrollController;
  const PricingSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock advanced models and premium features',
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
          ),
          const SizedBox(height: 24),
          const _PlanCard(
            title: 'Free',
            price: '\$0',
            features: const [
              ['✓', 'GPT-5.5, Gemini 3.1, DeepSeek V4'],
              ['✓', 'Limited to 50 messages/day'],
              ['✓', 'Standard response speed'],
              ['✗', 'No Claude Opus 4.7'],
              ['✗', 'No priority access'],
            ],
            cta: 'Current Plan',
            ctaEnabled: false,
            plan: UserPlan.free,
          ),
          const SizedBox(height: 16),
          const _PlanCard(
            title: 'Pro',
            price: '\$20',
            period: '/month',
            popular: true,
            features: const [
              ['✓', 'Claude Opus 4.7 access'],
              ['✓', 'Unlimited messages'],
              ['✓', 'Faster response times'],
              ['✓', 'Image & file uploads'],
              ['✓', 'Advanced voice mode'],
              ['✓', 'Priority support'],
            ],
            cta: 'Upgrade to Pro',
            ctaEnabled: true,
            plan: UserPlan.pro,
          ),
          const SizedBox(height: 16),
          const _PlanCard(
            title: 'Max',
            price: '\$100',
            period: '/month',
            features: const [
              ['✓', 'Everything in Pro'],
              ['✓', 'Extended thinking mode'],
              ['✓', '10M token context'],
              ['✓', 'Long-term memory across sessions'],
              ['✓', 'Multi-agent workflows'],
              ['✓', 'API access'],
            ],
            cta: 'Upgrade to Max',
            ctaEnabled: true,
            plan: UserPlan.max,
            outline: true,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Cancel anytime • 14-day money-back guarantee',
              style: TextStyle(fontSize: 12, color: colors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<List<String>> features;
  final String cta;
  final bool ctaEnabled;
  final UserPlan plan;
  final bool popular;
  final bool outline;

  const _PlanCard({
    required this.title,
    required this.price,
    this.period = '',
    required this.features,
    required this.cta,
    required this.ctaEnabled,
    required this.plan,
    this.popular = false,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = context.watch<SettingsProvider>();
    final isCurrent = settings.plan == plan;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: popular ? colors.primary.withOpacity(0.05) : null,
            border: Border.all(
              color: popular ? colors.primary : colors.border,
              width: popular ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          )),
                      if (period.isNotEmpty)
                        Text(period,
                            style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f[0],
                            style: TextStyle(
                              color: f[0] == '✓' ? colors.secondary : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f[1],
                            style: TextStyle(
                              fontSize: 14,
                              color: f[0] == '✓' ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: outline
                    ? OutlinedButton(
                        onPressed: ctaEnabled && !isCurrent
                            ? () => _upgrade(context, plan)
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: colors.primary, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          foregroundColor: colors.primary,
                        ),
                        child: Text(isCurrent ? 'Current Plan' : cta,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      )
                    : ElevatedButton(
                        onPressed: ctaEnabled && !isCurrent
                            ? () => _upgrade(context, plan)
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: colors.primary,
                          disabledBackgroundColor: colors.border,
                          disabledForegroundColor: colors.textTertiary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text(isCurrent ? 'Current Plan' : cta,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      ),
              ),
            ],
          ),
        ),
        if (popular)
          Positioned(
            top: -12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _upgrade(BuildContext context, UserPlan plan) {
    context.read<SettingsProvider>().upgradePlan(plan);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Upgraded to ${plan.name.toUpperCase()} plan (demo).'),
      ),
    );
  }
}
