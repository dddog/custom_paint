import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:custom_paint/paint/dot_info_model.dart';

final sizeStateProvider = StateProvider<double>((ref) => 3);
final colorStateProvider = StateProvider<Color>((ref) => Colors.black);
final eraseModeStateProvider = StateProvider<bool>((ref) => false);

final drawStateProvider =
    StateNotifierProvider<DrawNotifier, List<List<DotInfoModel>>>((ref) {
  return DrawNotifier(
    ref: ref,
  );
});

class DrawNotifier extends StateNotifier<List<List<DotInfoModel>>> {
  final Ref ref;
  DrawNotifier({
    required this.ref,
  }) : super([]);

  erase(Offset offset) {
    const int eraseGap = 15;
    for (var oneLine in List<List<DotInfoModel>>.from(state)) {
      for (DotInfoModel oneDot in oneLine) {
        if (sqrt(pow((offset.dx - oneDot.offset.dx), 2) +
                pow((offset.dy - oneDot.offset.dy), 2)) <
            eraseGap) {
          state.remove(oneLine);
          state = [...state];
          break;
        }
      }
    }
  }

  drawStart(Offset offset) {
    List<DotInfoModel> oneLine = <DotInfoModel>[];
    oneLine.add(DotInfoModel(
        offset, ref.read(sizeStateProvider), ref.read(colorStateProvider)));
    // state.add(oneLine);
    state = [
      ...state,
      oneLine,
    ];
  }

  drawUpdate(Offset offset) {
    state.last.add(DotInfoModel(
        offset, ref.read(sizeStateProvider), ref.read(colorStateProvider)));
    state = [...state];
  }
}
