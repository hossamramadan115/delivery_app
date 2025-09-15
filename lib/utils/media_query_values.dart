import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

// width: context.screenWidth * 0.8,
// height: context.screenHeight * 0.2,
