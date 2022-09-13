import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tictactoe/src/theme/prefrences.dart';

snackBar(GlobalKey<ScaffoldState> key, String text,
        {Color? color, int? seconds}) =>
    key.currentState!.showSnackBar(SnackBar(
      content: Text(text),
      elevation: 30,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(35)),
      backgroundColor: color ?? accentColor,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: seconds ?? 1500),
    ));

extension MyText on String {
  style(
      {Color? color, bool bold = true, double? letterSpacing, double? fontSize}) {
    return Text(
      this,
      style: GoogleFonts.stylish(
        fontWeight: bold ? FontWeight.bold : FontWeight.w600,
        color: color,
        letterSpacing: letterSpacing ?? 1.0,
        fontSize: fontSize ?? 15.sp,
      ),
    );
  }

  initials() {
    List<String> data = this.split(' ');
    return data.length > 1
        ? data.first.substring(0, 1) + data.last.substring(0, 1)
        : data.first.substring(0, 1);
  }
}
