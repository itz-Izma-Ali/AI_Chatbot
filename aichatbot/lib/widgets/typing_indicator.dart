import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'robot_icon.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [colors.primary, colors.primaryLight]),
          ),
          alignment: Alignment.center,
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: RobotIcon(size: 26),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.aiBubble,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => _dot(i, colors)),
          ),
        ),
      ],
    );
  }

  Widget _dot(int i, AppColors colors) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final delay = i * 0.2;
        var v = (_ctrl.value - delay) % 1.0;
        if (v < 0) v += 1;
        final dy = v < 0.3 ? -8 * (v / 0.3) : (v < 0.6 ? -8 * (1 - (v - 0.3) / 0.3) : 0.0);
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 4 : 0),
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: colors.textTertiary, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}
