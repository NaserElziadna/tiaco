import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/src/theme/prefrences.dart';

class CircleCross extends StatefulWidget {
  final bool? circle;

  CircleCross({this.circle});

  @override
  _CircleCrossState createState() => _CircleCrossState();
}

class _CircleCrossState extends State<CircleCross>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {
              _fraction = _animation.value;
            });
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(22),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FadeScaleTransition(
            animation: _animationController,
            child: CustomPaint(
              painter: widget.circle!
                  ? CirclePainter(fraction: _fraction)
                  : CrossPainter(fraction: _fraction),
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double? fraction;
  Paint? circlePaint;

  CirclePainter({this.fraction}) {
    circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset(0.0, 0.0) & size;
    canvas.drawArc(rect, -pi / 2, pi * 2 * fraction!, false, circlePaint!);
  }

  @override
  bool shouldRepaint(CirclePainter old) => old.fraction != fraction;
}

class CrossPainter extends CustomPainter {
  final double? fraction;
  Paint? crossPaint;

  CrossPainter({this.fraction}) {
    crossPaint = Paint()
      ..color = crossColor
      ..strokeWidth = 16.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double leftLine, rightLine;

    if (fraction! < 0.5) {
      leftLine = fraction! / 0.5;
      rightLine = 0.0;
    } else {
      leftLine = 1.0;
      rightLine = (fraction! - 0.5) / 0.5;
    }

    canvas.drawLine(Offset(0.0, 0.0),
        Offset(size.width * leftLine, size.height * leftLine), crossPaint!);

    if (fraction! >= .5) {
      canvas.drawLine(
          Offset(size.width, 0.0),
          Offset(size.width - size.width * rightLine, size.height * rightLine),
          crossPaint!);
    }
  }

  @override
  bool shouldRepaint(CrossPainter old) => old.fraction != fraction;
}