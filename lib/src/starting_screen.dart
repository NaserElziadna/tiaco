import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tictactoe/src/main_screen.dart';
import 'package:tictactoe/src/models/game_stat.dart';
import 'package:tictactoe/src/services/db_service.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';
import 'package:tictactoe/src/services/sign_in_service.dart';
import 'package:tictactoe/src/services/sound_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/utils/text_data.dart';
import 'package:tictactoe/src/utils/user_input_dialog.dart';

class StartingScreen extends StatefulWidget {
  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool value = true;

  init() async {
    value = await SharedService().firstTime;
    if (value) {
      Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen())),
      );
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      key: _globalKey,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'),
                  // backgroundColor: Colors.black,
                backgroundColor: Colors.transparent,
                  minRadius: width(context) * 0.25,
                  maxRadius:
                      !value ? width(context) * 0.30 : width(context) * 0.35,
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.stylish(
                      color: crossColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: 'Tic '),
                      TextSpan(
                          text: 'Tac ',
                          style: GoogleFonts.stylish(color: circleColor)),
                      TextSpan(text: 'Toe'),
                    ],
                  ),
                ),
                Text(
                  'Let the fun begins!',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w700,
                      ),
                )
              ],
            ),
            if (!value)
              button(
                title: 'Start the Game',
                onTap: () async {
                  SoundService().playSound('click');

                  List<dynamic> data = await SignInActivity.signIn();
                  if (data[0]) {
                    await SharedService().setFirstTime();
                    DBService dbService = DBService();
                    await dbService.insert(
                        GameStat(data: 'single', wins: 0, losses: 0, draws: 0));
                    await dbService.insert(
                        GameStat(data: 'multi', wins: 0, losses: 0, draws: 0));
                    await dbService.insert(GameStat(
                        data: 'single_medium', wins: 0, losses: 0, draws: 0));
                    await dbService.insert(GameStat(
                        data: 'single_expert', wins: 0, losses: 0, draws: 0));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  } else {
                    snackBar(_globalKey, data[1], color: Colors.red);
                    showModal(
                      configuration: FadeScaleTransitionConfiguration(
                          barrierDismissible: false),
                      context: context,
                      builder: (context) => UserInputDialog(),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  button({void Function()? onTap, String? title}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton.icon(
        onPressed: onTap,
        label: Text(
          title!,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: crossColor,
          ),
        ),
        icon: FaIcon(FontAwesomeIcons.gamepad, color: circleColor),
        // padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
