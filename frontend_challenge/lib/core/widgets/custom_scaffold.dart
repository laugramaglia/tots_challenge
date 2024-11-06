import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend_challenge/core/extensions/context.dart';
import 'package:frontend_challenge/core/theme/app_pallete.dart';
import 'dart:math' as math;

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;
  const CustomScaffold(
      {super.key,
      this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 32)});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            right: -50,
            top: -120,
            child: TriangleWidget(
                color: Pallete.primaryColor, sice: 460, radius: 200),
          ),
          const Positioned(
            left: -150,
            bottom: 100,
            top: 100,
            child: CircleAvatar(
              backgroundColor: Pallete.primaryColor,
              radius: 100,
            ),
          ),
          const Positioned(
            left: 20,
            right: 20,
            bottom: -100,
            child: CircleAvatar(
              backgroundColor: Pallete.primaryColor,
              radius: 100,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                color: context.colorScheme.surface.withOpacity(.2),
                padding: padding,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleWidget extends StatelessWidget {
  final Color color;
  final double radius;
  final double sice;
  const TriangleWidget({
    super.key,
    required this.color,
    this.radius = 80,
    this.sice = 200,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: CustomPaint(
        painter: TrianglePainter(color: color, borderRadius: radius),
        size: Size.square(sice),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  TrianglePainter({
    required this.color,
    this.borderRadius = 20,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round;

    // Create points
    const point1 = Offset(0, 0);
    final point2 = Offset(size.width / 2, size.height);
    final point3 = Offset(size.width, 0);

    final path = Path();

    // Helper function to calculate points for rounded corners
    Offset calculatePoint(Offset start, Offset end, double radius) {
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      final unitX = dx / distance;
      final unitY = dy / distance;

      return Offset(
        start.dx + unitX * radius,
        start.dy + unitY * radius,
      );
    }

    // Calculate rounded points
    final point1To2 = calculatePoint(point1, point2, borderRadius);
    final point2To1 = calculatePoint(point2, point1, borderRadius);
    final point2To3 = calculatePoint(point2, point3, borderRadius);
    final point3To2 = calculatePoint(point3, point2, borderRadius);
    final point3To1 = calculatePoint(point3, point1, borderRadius);
    final point1To3 = calculatePoint(point1, point3, borderRadius);

    // Draw the path with quadratic curves for rounded corners
    path.moveTo(point1To2.dx, point1To2.dy);
    path.quadraticBezierTo(point1.dx, point1.dy, point1To3.dx, point1To3.dy);
    path.lineTo(point3To1.dx, point3To1.dy);
    path.quadraticBezierTo(point3.dx, point3.dy, point3To2.dx, point3To2.dy);
    path.lineTo(point2To3.dx, point2To3.dy);
    path.quadraticBezierTo(point2.dx, point2.dy, point2To1.dx, point2To1.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
