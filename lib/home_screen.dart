import 'package:custom_paint/custom_paint_screen.dart';
import 'package:custom_paint/paint/paint_screen.dart';
import 'package:custom_paint/zoom/zoom_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CustomPaintScreen(),
                  ));
                },
                child: const Text('CustomPaintScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaintScreen(),
                  ));
                },
                child: const Text('기본 패인트 프로그램'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ZoomScreen(),
                  ));
                },
                child: const Text('Zoom Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
