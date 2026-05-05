import 'package:flutter/material.dart';

class RobotIcon extends StatefulWidget {
  final double size;
  final bool animate;
  const RobotIcon({super.key, this.size = 64, this.animate = true});

  @override
  State<RobotIcon> createState() => _RobotIconState();
}

class _RobotIconState extends State<RobotIcon> with TickerProviderStateMixin {
  late final AnimationController _bounce;
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _blink = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    if (widget.animate) {
      _bounce.repeat(reverse: true);
      _blink.repeat();
    }
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
        final t = _blink.value;
        final eyesOpen = !(t > 0.46 && t < 0.54);
        final dy = -widget.size *
            0.04 *
            (1 - (2 * _bounce.value - 1).abs());
        return Transform.translate(
          offset: Offset(0, dy),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _RobotPainter(eyesOpen: eyesOpen),
            ),
          ),
        );
      },
    );
  }
}

class _RobotPainter extends CustomPainter {
  final bool eyesOpen;
  _RobotPainter({required this.eyesOpen});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Antennas (red curved bars)
    final antennaPaint = Paint()
      ..color = const Color(0xFFE53E3E)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = w * 0.07;

    final leftAntenna = Path()
      ..moveTo(w * 0.20, h * 0.30)
      ..quadraticBezierTo(w * 0.10, h * 0.20, w * 0.18, h * 0.05);
    final rightAntenna = Path()
      ..moveTo(w * 0.80, h * 0.30)
      ..quadraticBezierTo(w * 0.90, h * 0.20, w * 0.82, h * 0.05);
    canvas.drawPath(leftAntenna, antennaPaint);
    canvas.drawPath(rightAntenna, antennaPaint);

    // Antenna tips (small red dots)
    final tipPaint = Paint()..color = const Color(0xFFE53E3E);
    canvas.drawCircle(Offset(w * 0.18, h * 0.05), w * 0.045, tipPaint);
    canvas.drawCircle(Offset(w * 0.82, h * 0.05), w * 0.045, tipPaint);

    // Yellow top bar
    final yellowPaint = Paint()..color = const Color(0xFFFFC93C);
    final yellowRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.32, h * 0.20, w * 0.36, h * 0.08),
      Radius.circular(w * 0.03),
    );
    canvas.drawRRect(yellowRect, yellowPaint);

    // Head (rounded square, light gray with subtle gradient)
    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.26, w * 0.76, h * 0.62),
      Radius.circular(w * 0.18),
    );
    final headGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFFF5F5F7), Color(0xFFD1D5DB)],
      ).createShader(headRect.outerRect);
    canvas.drawRRect(headRect, headGradient);

    // Inner darker face panel (where eyes sit)
    final facePanelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.40, w * 0.60, h * 0.32),
      Radius.circular(w * 0.10),
    );
    canvas.drawRRect(
      facePanelRect,
      Paint()..color = const Color(0xFF1F2937),
    );

    // Eyes (cyan glowing ovals)
    final eyeColor = const Color(0xFF38BDF8);
    final eyeRadius = w * 0.06;
    final eyeY = h * 0.56;

    if (eyesOpen) {
      // Glow halo
      final glowPaint = Paint()
        ..color = eyeColor.withOpacity(0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.04);
      canvas.drawCircle(Offset(w * 0.36, eyeY), eyeRadius * 1.4, glowPaint);
      canvas.drawCircle(Offset(w * 0.64, eyeY), eyeRadius * 1.4, glowPaint);

      final eyePaint = Paint()..color = eyeColor;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.36, eyeY), width: eyeRadius * 2.2, height: eyeRadius * 2.4),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.64, eyeY), width: eyeRadius * 2.2, height: eyeRadius * 2.4),
        eyePaint,
      );

      // Eye highlights
      final highlight = Paint()..color = Colors.white.withOpacity(0.85);
      canvas.drawCircle(Offset(w * 0.34, eyeY - eyeRadius * 0.5), eyeRadius * 0.35, highlight);
      canvas.drawCircle(Offset(w * 0.62, eyeY - eyeRadius * 0.5), eyeRadius * 0.35, highlight);
    } else {
      // Closed eyes (lines)
      final closedPaint = Paint()
        ..color = eyeColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.025;
      canvas.drawLine(
        Offset(w * 0.30, eyeY),
        Offset(w * 0.42, eyeY),
        closedPaint,
      );
      canvas.drawLine(
        Offset(w * 0.58, eyeY),
        Offset(w * 0.70, eyeY),
        closedPaint,
      );
    }

    // Side ears (small gray bumps)
    final earPaint = Paint()..color = const Color(0xFFD1D5DB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.06, h * 0.46, w * 0.08, h * 0.18),
        Radius.circular(w * 0.04),
      ),
      earPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.86, h * 0.46, w * 0.08, h * 0.18),
        Radius.circular(w * 0.04),
      ),
      earPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RobotPainter old) => old.eyesOpen != eyesOpen;
}
