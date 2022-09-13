import 'dart:io';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/components/circle_cross.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';
import 'package:tictactoe/src/services/sign_in_service.dart';
import 'package:tictactoe/src/services/sound_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/theme/routes.dart';
import 'package:tictactoe/src/utils/about_me_page.dart';
import 'package:tictactoe/src/utils/button.dart';
import 'package:tictactoe/src/utils/choose_difficulty.dart';
import 'package:tictactoe/src/utils/create_room_dialog.dart';
import 'package:tictactoe/src/utils/player_names.dart';
import 'package:tictactoe/src/utils/profile_dialog.dart';
import 'package:tictactoe/src/utils/text_data.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late GameProvider gameProvider;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final SoundService soundService = SoundService();

  final File imageFile = File(GameProvider().photoUrl);
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    photoUrl = await SharedService().photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, value, child) {
        gameProvider = value;

        return Scaffold(
          key: _globalKey,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: const EdgeInsets.fromLTRB(15, 35, 15, 15),
            child: Column(
              children: [
                appBar(context),
                Flexible(child: main()),
                bottom(context)
              ],
            ),
          ),
        );
      },
    );
  }

  appBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                soundService.playSound('click');
                Provider.of<GameProvider>(context, listen: false)
                    .init()
                    .then((value) {
                  if (value) {
                    return showModal(
                      context: context,
                      configuration: FadeScaleTransitionConfiguration(
                        transitionDuration: Duration(milliseconds: 300),
                        barrierDismissible: false,
                      ),
                      builder: (context) => ProfileDialog(photoUrl),
                    );
                  }
                });
              },
              child: imageFile.existsSync() || photoUrl.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 1,
                            color: accentColor.withOpacity(0.8),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: photoUrl.isEmpty
                            ? FileImage(imageFile) as ImageProvider<Object>?
                            : NetworkImage(photoUrl),
                        radius: 28,
                      ),
                    )
                  : CircleAvatar(
                      child: gameProvider.name != null
                          ? Text(
                              gameProvider.name.initials(),
                              style: GoogleFonts.stylish(
                                fontWeight: FontWeight.w600,
                                color: crossColor,
                                fontSize: 22.sp,
                              ),
                            )
                          : Text(''),
                      radius: 28,
                      backgroundColor: crossColor.withOpacity(0.2),
                    ),
            ),
            'Coins: ${gameProvider.bucks}'.style(
                color: Colors.green.shade800,
                fontSize: 22.sp,
                letterSpacing: 1.2),
            SizedBox(
              height: width(context) * 0.15,
              width: width(context) * 0.15,
              child: Button(
                iconData: FontAwesomeIcons.music,
                icon: true,
                color: accentColor,
                onPressed: () {},
              ),
            )
          ],
        ),
        // SizedBox(height: 7),
        // Row(
        //   children: [
        //     Expanded(
        //       child: OutlineButton.icon(
        //         onPressed: () async {
        //           try {
        //             if (await SharedService().playGames) {
        //               PlayGames.showAchievements();
        //             } else {
        //               SigninResult signinResult = await PlayGames.signIn();
        //               if (signinResult.success) {
        //                 SharedService().setPlayGames(gameProvider);
        //                 PlayGames.showAchievements();
        //               } else
        //                 snackBar(_globalKey, signinResult.message);
        //             }
        //           } catch (e) {
        //             snackBar(_globalKey, e.toString());
        //           }
        //         },
        //         icon: FaIcon(FontAwesomeIcons.play, color: accentColor),
        //         label: Text('Achievements'),
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(8)),
        //       ),
        //     ),
        //     SizedBox(width: 20),
        //     Expanded(
        //       child: OutlineButton.icon(
        //         onPressed: () async {
        //           try {
        //             if (await SharedService().playGames) {
        //               PlayGames.showAllLeaderboards();
        //             } else {
        //               SigninResult signinResult = await PlayGames.signIn();
        //               if (signinResult.success) {
        //                 SharedService().setPlayGames(gameProvider);
        //                 PlayGames.showAllLeaderboards();
        //               } else
        //                 snackBar(_globalKey, signinResult.message);
        //             }
        //           } catch (e) {
        //             snackBar(_globalKey, e.toString());
        //           }
        //         },
        //         icon: FaIcon(FontAwesomeIcons.chartLine, color: crossColor),
        //         label: Text('Leaderboard'),
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(8)),
        //       ),
        //     )
        //   ],
        // )
      ],
    );
  }

  main() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: CircleCross(circle: true)),
              Expanded(child: CircleCross(circle: false))
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: CircleCross(circle: false)),
              Expanded(child: CircleCross(circle: true))
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.stylish(
                color: crossColor,
                fontSize: 45.sp,
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
        ),
      ],
    );
  }

  bottom(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Button(
            color: crossColor,
            text: 'Play',
            onPressed: () {
              soundService.playSound('click');
              Provider.of<GameProvider>(context, listen: false)
                  .init()
                  .then((value) {
                if (value) {
                  return showModal(
                    context: context,
                    configuration: const FadeScaleTransitionConfiguration(
                      transitionDuration: Duration(milliseconds: 300),
                      barrierDismissible: false,
                    ),
                    builder: (context) => DifficultyChooser(),
                  );
                }
              });
            },
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 50,
          child: Button(
              color: circleColor,
              text: 'Play with Friends',
              onPressed: () {
                soundService.playSound('click');
                Provider.of<GameProvider>(context, listen: false)
                    .init()
                    .then((value) {
                  if (value) {
                    return showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(
                        transitionDuration: Duration(milliseconds: 300),
                        barrierDismissible: false,
                      ),
                      builder: (context) => PlayerName(),
                    );
                  }
                });
              }),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 50,
          child: Button(
            color: accentColor,
            text: 'Online Multiplayer',
            onPressed: () {
              soundService.playSound('click');

              SignInActivity.check.then((value) async {
                if (value) {
                  navigateToOnlineGame();
                } else {
                  snackBar(_globalKey,
                      'You need to sign in to the account in order to continue... 👨‍💻');
                  List<dynamic> list = await SignInActivity.signIn();
                  if (list[0]) {
                    snackBar(_globalKey, 'Successfully Signed In... ✔✔ 👨‍');
                    navigateToOnlineGame();
                  } else {
                    snackBar(_globalKey, 'Error: ${list[1]}',
                        color: Colors.redAccent);
                  }
                }
              });
            },
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 50,
          child: Button(
            color: accentColor,
            text: 'About Me',
            onPressed: () {
              soundService.playSound('click');
              navigateToAboutMe();
            },
          ),
        ),
      ],
    );
  }

  navigateToOnlineGame() => push(context, CreateRoomDialog());
  navigateToAboutMe() => push(context, AboutMePage());
}
