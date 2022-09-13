import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/components/circle_cross.dart';
import 'package:tictactoe/src/components/equal.dart';
import 'package:tictactoe/src/components/game_board.dart';
import 'package:tictactoe/src/components/winner_line.dart';
import 'package:tictactoe/src/models/game_stat.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/services/sound_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/theme/routes.dart';
import 'package:tictactoe/src/utils/button.dart';
import 'package:tictactoe/src/utils/custom_simple_dialog.dart';
import 'package:tictactoe/src/utils/text_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SinglePlayer extends StatefulWidget {
  @override
  _SinglePlayerState createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer>
    with SingleTickerProviderStateMixin {
  late GameProvider gameProvider;
  late AnimationController _animationController;
  double value = 0.0;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  SoundService soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {
          value = _animationController.value;
        });
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
//    _nativeAdmobController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, value, child) {
        gameProvider = value;
        gameProvider.setContext = context;
        gameProvider.key = _globalKey;
        gameProvider.animation = _animationController;
        return Scaffold(
          key: _globalKey,
          body: Container(
            height: height(context),
            margin: EdgeInsets.only(left: 15, right: 15.0, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                scoreBoard(),
                if (!gameProvider.singlyGame)
                  userNames(
                      gameProvider.playerName.isEmpty
                          ? 'Player 2'
                          : gameProvider.playerName,
                      1,
                      gameProvider.activePlayer == AVATAR.X),
                Flexible(child: gameBoard()),
                if (!gameProvider.singlyGame)
                  userNames(gameProvider.name, 0,
                      gameProvider.activePlayer == AVATAR.O),
                bottomBar()
              ],
            ),
          ),
        );
      },
    );
  }

  scoreBoard() {
    GameStat gameStat =
        gameProvider.listGameStat[gameProvider.getCurrentGameStat()[1]];

    return Column(
      children: [
//        adMobService.nativeAd(context, _nativeAdmobController),
        if (gameProvider.singlyGame)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Current Streak: ${gameProvider.currentStreak}'
                  .style(color: Colors.deepOrange, fontSize: 20.sp),
              'Highest Streak: ${gameProvider.streak}'
                  .style(color: Colors.green, fontSize: 20.sp),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            drawAvatar(
                '${gameProvider.singlyGame ? gameStat.wins : gameProvider.wins} Wins',
                CircleCross(circle: true),
                circleColor),
            drawAvatar(
                '${gameProvider.singlyGame ? gameStat.draws : gameProvider.draws} Draws',
                Equal(),
                accentColor),
            drawAvatar(
                '${gameProvider.singlyGame ? gameStat.losses : gameProvider.losses} Wins',
                CircleCross(circle: false),
                crossColor)
          ],
        ),
      ],
    );
  }

  Widget drawAvatar(String score, Widget child, Color color) {
    return Column(
      children: [
        SizedBox(
            height: width(context) * 0.30,
            width: width(context) * 0.30,
            child: child),
        '$score'.style(color: color, fontSize: 25.sp, letterSpacing: 1.2)
      ],
    );
  }

  gameBoard() {
    return AnimatedOpacity(
      opacity: value,
      duration: Duration(seconds: 1),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
          painter: CustomGameBoard(value: value),
          foregroundPainter: !gameProvider.winningState.isNegative
              ? CustomWinnerLine(gameProvider.winningState)
              : null,
          child: Container(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 9,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                int row = index ~/ 3, col = index % 3;
                return gameProvider.gameTileButton(row, col);
              },
            ),
          ),
        ),
      ),
    );
  }

  bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: width(context) * 0.15,
          width: gameProvider.singlyGame
              ? width(context) * 0.15
              : width(context) * 0.90,
          child: Button(
            iconData: FontAwesomeIcons.times,
            icon: true,
            color: Colors.redAccent,
            onPressed: () {
              soundService.playSound('click');
              showModal<void>(
                context: context,
                configuration: FadeScaleTransitionConfiguration(),
                builder: (context) => CustomSimpleDialog(
                  title: 'Are you sure to exit the game?',
                  actions: [
                    [
                      'Yes',
                      () {
                        pop(context);
                        pop(context);
                      },
                      Colors.redAccent
                    ],
                    ['No', () => pop(context), Colors.green]
                  ],
                ),
              );
            },
          ),
        ),
        if (gameProvider.singlyGame)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                animationDuration: Duration(milliseconds: 500),
                elevation: 10,
                color: gameProvider.gameDiff() == 0
                    ? Colors.teal
                    : gameProvider.gameDiff() == 1
                        ? Colors.deepOrangeAccent
                        : Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: DropdownButton(
                    value: gameProvider.gameDifficulty,
                    elevation: 8,
                    items: [
                      DropdownMenuItem(
                        child: Text('Easy'),
                        value: GAME_DIFFICULITY.EASY,
                      ),
                      DropdownMenuItem(
                        child: Text('Medium'),
                        value: GAME_DIFFICULITY.MEDIUM,
                      ),
                      DropdownMenuItem(
                        child: Text('Expert'),
                        value: GAME_DIFFICULITY.EXPERT,
                      )
                    ],
                    style: GoogleFonts.stylish(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    dropdownColor: Colors.blueGrey,
                    underline: Container(),
                    onChanged: (value) {
                      soundService.playSound('click');
                      gameProvider.setGameDifficulty(value as GAME_DIFFICULITY);
                      snackBar(_globalKey,
                          'Game difficulty has been changed to ${value.toString().split('.').last}');
                    },
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  userNames(String name, int i, bool condition) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        '$name'
            .style(color: i == 0 ? circleColor : crossColor, fontSize: 25.sp),
        SizedBox(width: 10),
        if (condition) FaIcon(FontAwesomeIcons.thumbsUp)
      ],
    );
  }
}