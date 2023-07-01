import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';

import 'my_painter.dart';

class CustomPaintScreen extends StatefulWidget {
  const CustomPaintScreen({super.key});

  @override
  State<CustomPaintScreen> createState() => _CustomPaintScreenState();
}

class _CustomPaintScreenState extends State<CustomPaintScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  Color color = Colors.grey;
  Paint p1 = Paint()..strokeWidth = 1;
  Paint p2 = Paint()
    ..strokeWidth = 1
    ..color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTapDown: (details) {
                // print(details.localPosition);
                // setState(() {});
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
              ),
            ),
            Container(
              color: Colors.black12,
              width: 200,
              height: 200,
              child: InteractiveViewer(
                // constrained: false,
                maxScale: 2.4,
                minScale: 0.5,
                // boundaryMargin: const EdgeInsets.all(20),
                onInteractionStart: (details) {
                  print('start : ${details.focalPoint}');
                  setState(() {
                    // color = Colors.red;
                    p1.color = Colors.red;
                  });
                },
                onInteractionUpdate: (details) {
                  print('update : ${details.focalPoint}');
                },
                onInteractionEnd: (details) {
                  print('end : $details');
                },
                child: CustomPaint(
                  painter: MyPainter(
                    context,
                    color,
                    p1,
                    p2,
                  ),
                  // foregroundPainter: MyForegroundPainter(),
                ),
              ),
            ),
            ImagePainter.network(
              'https://blog.codemagic.io/uploads/covers/codemagic-blog-multi-touch-canvas-with-flutter.png',
              key: _imageKey,
            ),
          ],
        ),
      ),
    );
  }
}
