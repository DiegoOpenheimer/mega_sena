import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Padding padding(EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: this,
    );
  }

  Container margin(EdgeInsets insets) {
    return Container(
      margin: insets,
      child: this,
    );
  }
}