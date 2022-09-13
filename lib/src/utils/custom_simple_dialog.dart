import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSimpleDialog extends StatelessWidget {
  final String title;
  final List<dynamic>? actions;

  CustomSimpleDialog({this.title = '', this.actions});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: actions!
          .map<Widget>(
            (data) => SimpleDialogOption(
              onPressed: data[1],
              child: Center(
                child: Text(
                  data[0],
                  style: GoogleFonts.stylish(
                      color: data[2],
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}