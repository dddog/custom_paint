import 'package:flutter/material.dart';

class PartDrawModel {
  final Path path;
  bool isSelected;
  PartDrawModel({
    required this.path,
    this.isSelected = false,
  });
}
