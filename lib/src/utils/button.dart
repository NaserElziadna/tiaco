import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color color;
  final bool icon;
  final iconData;

  const Button(
      {this.onPressed ,
      this.text = "",
      this.color  = Colors.brown,
      this.icon = false,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(35)),
        color: color,
        elevation: 8,
        shadowColor: color.withOpacity(0.8),
        child: Container(
          width: width(context),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Center(
            child: icon
                ? FaIcon(iconData, color: Colors.white)
                : Text(
                    text,
                    style: GoogleFonts.stylish(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp,
                      letterSpacing: 1.1,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.white.withAlpha(70),
                          offset: Offset(2, 2),
                          blurRadius: 8,
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}