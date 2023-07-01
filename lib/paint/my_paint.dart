import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'dot_info_model.dart';

class MyPaint extends CustomPainter {
  final WidgetRef ref;
  final List<List<DotInfoModel>> lines;
  final ui.Image image;
  MyPaint({
    required this.ref,
    required this.lines,
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // image
    canvas.drawImage(image, Offset.zero, Paint());

    // part
    Path path1 = Path();
    path1.addPolygon([
      const Offset(150, 170),
      const Offset(160, 170),
      const Offset(160, 180),
      const Offset(150, 180),
    ], true);
    print(path1.contains(const Offset(149, 171)));
    canvas.drawPath(path1, Paint()..color = Colors.amber);

    // pen
    for (List<DotInfoModel> oneLine in lines) {
      Color? color;
      double? size;
      var l = <Offset>[];
      var p = Path();
      for (var oneDot in oneLine) {
        color = oneDot.color;
        size = oneDot.size;
        l.add(oneDot.offset);
      }
      p.addPolygon(l, false);
      Paint paint = Paint();
      paint.color = color ?? Colors.black;
      paint.strokeWidth = size ?? 3;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(
        p,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MyPaint oldDelegate) {
    return true;
  }
}
