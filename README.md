
This is a countdown to a pie chart that also takes on different colors as time presses.
这是一个饼状图的倒计时，随着时间的紧迫也会呈现不同的颜色

## Features

/*
* PieTimeWidget
* [
*   radius
*   [Bottom ring：
*    strokeWidth：边宽
*   ]
*   [top ring：
*    Color list：充裕黄色，预警渐变[黄色，红色]，紧张红色
*    Time slot：0, [0.5, 0.75], 1
*    progress：
*   ]
* ]
*
*
* **/
## Getting started

```dart
import 'package:pie_time_widget/pie_time_widget.dart';
```

## Usage

```dart
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
```

## Additional information

Have fun

