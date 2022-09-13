import 'package:flutter/material.dart';

class CustomGameBoard extends CustomPainter {
  Paint? customPaint;
  Paint? glowPaint;
  double? value;

  CustomGameBoard({this.value});

  @override
  void paint(Canvas canvas, Size size) {
    customPaint = Paint()
      ..color = Colors.blueGrey[200]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    glowPaint = Paint()
      ..color = Colors.blueGrey
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    // Horizontal Lines

    canvas.drawLine(Offset(size.width * 0.33, 0),
        Offset(size.width * 0.33, size.height * value!), customPaint!);
    canvas.drawLine(Offset(size.width * 0.66, 0),
        Offset(size.width * 0.66, size.height * value!), customPaint!);

    // Vertical Lines

    canvas.drawLine(Offset(0, size.height * 0.33),
        Offset(size.width * value!, size.height * 0.33), customPaint!);
    canvas.drawLine(Offset(0, size.height * 0.66),
        Offset(size.width * value!, size.height * 0.66), customPaint!);

    //glow section

    // Horizontal Lines

    canvas.drawLine(Offset(size.width * 0.33, 0),
        Offset(size.width * 0.33, size.height * value!), glowPaint!);
    canvas.drawLine(Offset(size.width * 0.66, 0),
        Offset(size.width * 0.66, size.height * value!), glowPaint!);

    // Vertical Lines

    canvas.drawLine(Offset(0, size.height * 0.33),
        Offset(size.width * value!, size.height * 0.33), glowPaint!);
    canvas.drawLine(Offset(0, size.height * 0.66),
        Offset(size.width * value!, size.height * 0.66), glowPaint!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
