class AIModel {
  final String id;
  final String name;
  final String description;
  final String? badge;
  final bool premium;

  const AIModel({
    required this.id,
    required this.name,
    required this.description,
    this.badge,
    this.premium = false,
  });

  static const List<AIModel> all = [
    AIModel(
      id: 'gpt55',
      name: 'GPT-5.5',
      description: 'Best all-rounder with agentic workflows (Apr 2026)',
      badge: 'LATEST',
    ),
    AIModel(
      id: 'opus47',
      name: 'Claude Opus 4.7',
      description: '87.6% SWE-bench - strongest for code (Apr 2026)',
      badge: 'CODING',
      premium: true,
    ),
    AIModel(
      id: 'gemini31',
      name: 'Gemini 3.1 Pro',
      description: '94.3% GPQA - best reasoning, 1M token context',
    ),
    AIModel(
      id: 'grok43',
      name: 'Grok 4.3',
      description: 'Real-time X data, video input, live research',
      premium: true,
    ),
    AIModel(
      id: 'deepseekv4',
      name: 'DeepSeek V4',
      description: '\$0.14/M tokens - cost-effective powerhouse',
      badge: 'BUDGET',
    ),
    AIModel(
      id: 'glm51',
      name: 'GLM-5.1',
      description: '58.4% SWE-bench - Chinese lab innovation',
    ),
  ];

  static AIModel byId(String id) => all.firstWhere((m) => m.id == id, orElse: () => all.first);
}

enum UserPlan { free, pro, max }
