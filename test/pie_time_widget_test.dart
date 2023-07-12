import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pie_time_widget/pie_time_widget.dart';

void main() {
  test('adds one to input values', () {

  });
}

Widget pieTimeWidget() {
  return RepaintBoundary(
    child: PieTimeWidget(
      50,
      0,
      const Color(0xFFFFE475).withOpacity(0.6),
      const Color(0xFFEC3530).withOpacity(0.6),
      5000,
      remainTime: 1000,
      endTimeCallback: () {
        // The countdown is over
      },
    ),
  );
}