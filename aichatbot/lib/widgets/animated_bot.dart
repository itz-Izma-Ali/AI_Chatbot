import 'package:flutter/material.dart';

class AnimatedBot extends StatefulWidget {
  final double size;
  const AnimatedBot({super.key, this.size = 24});

  @override
  State<AnimatedBot> createState() => _AnimatedBotState();
}

class _AnimatedBotState extends State<AnimatedBot> with TickerProviderStateMixin {
  late final AnimationController _bounce;
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _blink = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _bounce.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounce, _blink]),
      builder: (_, __) {
        final dy = -3 * (1 - (2 * _bounce.value - 1).abs()) * (widget.size / 24);
        final t = _blink.value;
        final visible = !(t > 0.46 && t < 0.54);
        return Transform.translate(
          offset: Offset(0, dy),
          child: SizedBox(
            width: widget.size * 1.1,
            height: widget.size * 1.1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '🤖',
                  style: TextStyle(
                    fontSize: widget.size,
                    shadows: const [
                      Shadow(blurRadius: 8, color: Color(0x33000000), offset: Offset(0, 2)),
                    ],
                  ),
                ),
                Positioned(
                  top: widget.size * 0.42,
                  child: Opacity(
                    opacity: visible ? 1 : 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _eye(),
                        SizedBox(width: widget.size * 0.25),
                        _eye(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _eye() {
    final s = widget.size * 0.12;
    return Container(
      width: s,
      height: s,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        shape: BoxShape.circle,
      ),
    );
  }
}
