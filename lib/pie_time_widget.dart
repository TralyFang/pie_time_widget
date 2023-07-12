library pie_time_widget;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
* 扇形时间倒计时
* [
*   radius
*   [底环：
*    strokeWidth：边宽
*   ]
*   [上环：
*    颜色档位：充裕黄色，预警渐变[黄色，红色]，紧张红色
*    时间档位：0, [0.5, 0.75], 1
*    进度：
*   ]
* ]
*
*
* **/
class PieTimeWidget extends StatefulWidget {
  double radius;
  double strokeWidth;
  Color startColor;
  Color endColor;
  int totalTime; // 毫秒
  int? remainTime; // 剩余多少毫秒, 动画从这里开始
  VoidCallback? endTimeCallback; // 时间结束

  PieTimeWidget(this.radius, this.strokeWidth, this.startColor, this.endColor,
      this.totalTime,
      {Key? key, this.endTimeCallback, this.remainTime})
      : super(key: key);

  @override
  _PieTimeWidgetState createState() => _PieTimeWidgetState();
}

class _PieTimeWidgetState extends State<PieTimeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  //控制饼图使用的
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.totalTime), vsync: this);

    //执行画饼的操作动画
    _progressAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _colorAnimation = ColorTween(begin: widget.startColor, end: widget.endColor)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.75, curve: Curves.linear),
    ));

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed || status == AnimationStatus.completed) {
        if (kDebugMode) {
          print("addStatusListener.status: $status");
        }
        // widget.endTimeCallback?.call();
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.remainTime != null && widget.remainTime! < widget.totalTime) {
        // 设置了仅剩时间，那就从这里开始吧
        _animationController.value = 1-widget.remainTime!/widget.totalTime;
      }
      _animationController.forward();
    });
  }

  @override
  void didUpdateWidget(PieTimeWidget oldWidget) {
    if (widget.remainTime != oldWidget.remainTime
        && widget.remainTime != null
        && widget.remainTime! < widget.totalTime) {
      // 设置了仅剩时间，那就从这里开始吧
      _animationController.reset();
      _animationController.value = 1-widget.remainTime!/widget.totalTime;
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  Color piesColor() {
    if (_animationController.value >= 1.0) widget.endTimeCallback?.call();
    if (_animationController.value < 0.5) return widget.startColor;
    if (_animationController.value > 0.75) return widget.endColor;
    return _colorAnimation.value ?? widget.endColor;
  }

  @override
  void dispose() {
    print("addStatusListener.dispose");
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: CustomPaint(
        painter: PiesTimePaint(
          _progressAnimation.value,
          piesColor(),
          widget.strokeWidth,
        ),
      ),
    );
  }
}

class PiesTimePaint extends CustomPainter {
  double progress;
  Color color;
  double strokeWidth;

  PiesTimePaint(this.progress, this.color, this.strokeWidth);

  late double radius;

//来个画笔
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = 10.0;

  @override
  void paint(Canvas canvas, Size size) {

    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;

    Offset centerOffset = const Offset(0, 0);
    double startAngle = -math.pi / 2;
    double endAngle = -2 * math.pi * progress;

    // 计算半径
    if (size.width > size.height) {
      radius = size.height / 2;
    } else {
      radius = size.width / 2;
    }
    // 将原点移动到画布中心
    canvas.translate(size.width / 2, size.height / 2);

    _paint.color = color;
    _paint.strokeWidth = strokeWidth;

    // 轮廓
    // _paint.style = PaintingStyle.stroke;
    // canvas.drawArc(Rect.fromCircle(center: centerOffset, radius: radius), 0,
    //     2 * math.pi, false, _paint);

    // 扇形
    _paint.style = PaintingStyle.fill;
    canvas.drawArc(Rect.fromCircle(center: centerOffset, radius: radius),
        startAngle, endAngle, true, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

