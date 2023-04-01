import 'package:flutter/material.dart';

typedef CloseLoadingScreen = bool Function();
typedef UpadteLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpadteLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
