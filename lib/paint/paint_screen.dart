import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:custom_paint/paint/draw_provider.dart';

import 'my_paint.dart';

class PaintScreen extends ConsumerStatefulWidget {
  const PaintScreen({super.key});

  @override
  ConsumerState<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends ConsumerState<PaintScreen> {
  ui.Image? image;
  late final TransformationController transformationController;

  @override
  void initState() {
    transformationController = TransformationController();
    init();
    super.initState();
  }

  @override
  dispose() {
    transformationController.dispose();
    super.dispose();
  }

  init() async {
    image = await loadImage('assets/images/front.png');
    ref.read(drawStateProvider.notifier).initPart();
  }

  @override
  Widget build(BuildContext context) {
    final bool eraseMode = ref.watch(eraseModeStateProvider);
    final bool selectMode = ref.watch(selectModeStateProvider);
    final drawState = ref.watch(drawStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('기본 페인트 프로그램'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: image == null
                      ? Container()
                      : InteractiveViewer(
                          transformationController: transformationController,
                          panEnabled: false,
                          onInteractionStart: (details) {
                            // print('start:${details.pointerCount}');
                            if (details.pointerCount == 1) {
                              Offset offset = transformationController
                                  .toScene(details.localFocalPoint);
                              if (selectMode) {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .select(offset);
                              } else if (eraseMode) {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .erase(offset);
                              } else {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .drawStart(offset);
                              }
                            }
                          },
                          onInteractionUpdate: (details) {
                            // print('update:${details.pointerCount}');
                            if (details.pointerCount == 1) {
                              Offset offset = transformationController
                                  .toScene(details.localFocalPoint);
                              print(
                                  'update:${details.localFocalPoint}, $offset');
                              if (selectMode) {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .select(offset);
                              } else if (eraseMode) {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .erase(offset);
                              } else {
                                ref
                                    .read(drawStateProvider.notifier)
                                    .drawUpdate(offset);
                              }
                            }
                          },
                          child: CustomPaint(
                            painter: MyPaint(
                              ref: ref,
                              lines: drawState,
                              image: image!,
                            ),
                          ),
                        ),
                  // child: FutureBuilder(
                  //     future: loadImage('assets/images/front.png'),
                  //     builder: (context, AsyncSnapshot<ui.Image> snapshot) {
                  //       switch (snapshot.connectionState) {
                  //         case ConnectionState.waiting:
                  //           return const Text('Image loading...');
                  //         default:
                  //           if (snapshot.hasError) {
                  //             return Text('Error: ${snapshot.error}');
                  //           } else {
                  //             return CustomPaint(
                  //               painter: DrawingPainter(
                  //                 ref: ref,
                  //                 lines: drawState,
                  //                 image: snapshot.data!,
                  //               ),
                  //             );
                  //           }
                  //       }
                  //     }),
                ),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   onPanStart: (details) {
                //     if (eraseMode) {
                //       ref
                //           .read(drawStateProvider.notifier)
                //           .erase(details.localPosition);
                //     } else {
                //       ref
                //           .read(drawStateProvider.notifier)
                //           .drawStart(details.localPosition);
                //     }
                //   },
                //   onPanUpdate: (details) {
                //     if (eraseMode) {
                //       ref
                //           .read(drawStateProvider.notifier)
                //           .erase(details.localPosition);
                //     } else {
                //       ref
                //           .read(drawStateProvider.notifier)
                //           .drawUpdate(details.localPosition);
                //     }
                //   },
                //   child: Container(),
                // ),
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorWidget(Colors.black),
                    _colorWidget(Colors.red),
                    _colorWidget(Colors.yellow),
                    _colorWidget(Colors.green),
                    _colorWidget(Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: ref.watch(sizeStateProvider),
                        min: 3,
                        max: 15,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        onChanged: (value) {
                          ref.read(sizeStateProvider.notifier).state = value;
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(selectModeStateProvider.notifier).state =
                            !selectMode;
                      },
                      child: Text(
                        '선택',
                        style: TextStyle(
                          fontSize: 20,
                          color: selectMode ? Colors.white : Colors.black12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(eraseModeStateProvider.notifier).state =
                            !eraseMode;
                      },
                      child: Text(
                        '지우개',
                        style: TextStyle(
                          fontSize: 20,
                          color: eraseMode ? Colors.white : Colors.black12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorWidget(Color color) {
    final selectedColor = ref.watch(colorStateProvider);
    return GestureDetector(
      onTap: () {
        ref.read(colorStateProvider.notifier).state = color;
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selectedColor == color
              ? Border.all(color: Colors.white, width: 4)
              : null,
        ),
      ),
    );
  }
}

Future<ui.Image> loadImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: 600,
    targetWidth: 300,
  );
  var frame = await codec.getNextFrame();
  return frame.image;
}
