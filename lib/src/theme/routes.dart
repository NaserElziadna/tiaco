import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

push(BuildContext context, Widget child) =>
    Navigator.push(context, pageRouteBuilder(child));

pushReplaced(BuildContext context, Widget child) =>
    Navigator.pushReplacement(context, pageRouteBuilder(child));

PageRouteBuilder pageRouteBuilder(Widget child) => PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeScaleTransition(animation: animation, child: child),
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child);

pop(BuildContext context) => Navigator.pop(context);
