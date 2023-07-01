import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final BuildContext context;
  Color color;
  final Paint p1;
  final Paint p2;
  MyPainter(
    this.context,
    this.color,
    this.p1,
    this.p2,
  );
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = color;

    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), const Offset(50, 50)),
      p1,
    );
    canvas.drawRect(
      Rect.fromPoints(const Offset(60, 0), const Offset(110, 50)),
      p2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // throw false;
    return oldDelegate != this;
  }
}
