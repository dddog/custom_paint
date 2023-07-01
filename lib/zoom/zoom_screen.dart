import 'package:flutter/material.dart';

class ZoomScreen extends StatelessWidget {
  const ZoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          '줌',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              // panEnabled: false,
              maxScale: 3,
              minScale: 1,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/front.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: const Text('asdfasf'),
          ),
        ],
      ),
    );
  }
}
