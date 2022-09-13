import 'package:flutter/material.dart';
import 'package:tictactoe/src/theme/prefrences.dart';

class CustomWinnerLine extends CustomPainter {
  Paint? customPaint;
  final int? value;
  double? pointOne, pointTwo, pointThree, pointFour;
  CustomWinnerLine(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    customPaint = Paint()
      ..color = accentColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    if (value! <= 2) {
      pointOne = 0;
      if (value == 2) {
        pointTwo = size.height * 0.825;
        pointFour = size.height * 0.825;
      } else if (value == 1) {
        pointTwo = size.height * 0.495;
        pointFour = size.height * 0.495;
      } else {
        pointTwo = size.height * 0.165;
        pointFour = size.height * 0.165;
      }
      pointThree = size.width;
    } else if (value! > 2 && value! <= 5) {
      if (value == 5) {
        pointOne = size.width * 0.825;
        pointThree = size.width * 0.825;
      } else if (value == 4) {
        pointOne = size.width * 0.495;
        pointThree = size.width * 0.495;
      } else {
        pointOne = size.width * 0.165;
        pointThree = size.width * 0.165;
      }
      pointTwo = 0;
      pointFour = size.height;
    } else if (value == 6) {
      pointOne = size.width * 0.125;
      pointTwo = size.height * 0.125;
      pointThree = size.height - size.width * 0.125;
      pointFour = size.height - size.width * 0.125;
    } else {
      pointOne = size.width - size.width * 0.125;
      pointTwo = size.width * 0.125;
      pointThree = size.height * 0.125;
      pointFour = size.height - size.width * 0.125;
    }

    canvas.drawLine(
        Offset(pointOne!, pointTwo!), Offset(pointThree!, pointFour!), customPaint!);
  }

  @override
  bool shouldRepaint(CustomWinnerLine old) => false;
}