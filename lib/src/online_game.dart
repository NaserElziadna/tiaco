import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/components/circle_cross.dart';
import 'package:tictactoe/src/components/game_board.dart';
import 'package:tictactoe/src/components/winner_line.dart';
import 'package:tictactoe/src/constants.dart';
import 'package:tictactoe/src/main_screen.dart';
import 'package:tictactoe/src/models/online_game_model.dart';
//import 'package:tictactoe/src/services/admob_service.dart';
import 'package:tictactoe/src/services/database_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/theme/routes.dart';
import 'package:tictactoe/src/utils/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tictactoe/src/utils/custom_simple_dialog.dart';
import 'package:tictactoe/src/utils/text_data.dart';

class OnlineGame extends StatefulWidget {
  final String roomID;
  final int playerCode;

  OnlineGame(this.roomID, this.playerCode);

  @override
  _OnlineGameState createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    Timer(const Duration(seconds: 2), () {
      if (widget.playerCode == 1) {
        pendingRef.doc(widget.roomID.substring(0, 5)).delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<OnlineGameModel>.value(
      initialData: OnlineGameModel(),
      value: DatabaseService(roomID: widget.roomID).room,
      builder: (context, child) => PlayingState(widget.playerCode),
    );
  }
}

class PlayingState extends StatefulWidget {
  final int playerCode;

  PlayingState(this.playerCode);

  @override
  _PlayingStateState createState() => _PlayingStateState();
}

class _PlayingStateState extends State<PlayingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double value = 0.0;
  int games = 0;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late OnlineGameModel gameModel;
  List _list =
      List<List<int>>.generate(3, (i) => List<int>.generate(3, (j) => -1));

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnlineGameModel>(
      builder: (context, value1, child) {
        gameModel = value1;
        if (value1 != null)
          value1.status != 200
              ? _animationController.reverse()
              : _animationController.forward();

        return value1 != null
            ? Scaffold(
                key: _key,
                resizeToAvoidBottomInset: false,
                body: Container(
                  margin: const EdgeInsets.fromLTRB(15, 12, 15, 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      topBar(),
                      value1.status == 200
                          ? Flexible(child: board())
                          : value1.status == 404
                              ? '${value1.stats!['playerOne'] > value1.stats!['playerTwo'] ? '${value1.playerOne!['name']}' : '${value1.playerTwo!['name']}'} Winner!!! 🥳🏆'
                                  .style(
                                  color: accentColor,
                                  letterSpacing: 1.2,
                                  fontSize: 25.sp,
                                )
                              : '${value1.winner} Winner!!! 🥳🏆'.style(
                                  color: accentColor,
                                  letterSpacing: 1.2,
                                  fontSize: 25.sp,
                                ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          child: bottomBar(),
                          height: height(context) > 600 ? 130 : 65,
                        ),
                        transitionBuilder: (child, animation) =>
                            FadeScaleTransition(
                                animation: animation, child: child),
                      ),
                      options()
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Tic Tac Toe: Online Multiplayer'),
                ),
              );
      },
    );
  }

  topBar() {
    return Column(
      children: [
//        AdMobService().nativeAd(context, NativeAdmobController()),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            playerProfile(0),
            RichText(
              text: TextSpan(
                children: [scoreStyle(0), TextSpan(text: ' : '), scoreStyle(1)],
                style: GoogleFonts.stylish(
                    fontSize: 35.sp, color: Colors.blueGrey),
              ),
            ),
            playerProfile(1)
          ],
        ),
      ],
    );
  }

  board() {
    return AnimatedOpacity(
      opacity: value,
      duration: Duration(seconds: 1),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
          painter: CustomGameBoard(value: value),
          foregroundPainter: !gameModel.winningState!.isNegative
              ? CustomWinnerLine(gameModel.winningState)
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
                return InkWell(
                  onTap: gameModel.active == widget.playerCode
                      ? playingBoard[row][col] == -1
                          ? () => onTap(row, col)
                          : () => showMessage(
                              'This cell is already taken by ${playingBoard[row][col] == 0 ? gameModel.playerOne!['name'] : gameModel.playerOne!['name']}',
                              color: Colors.red)
                      : () => showMessage(
                          '${gameModel.active == 0 ? gameModel.playerOne!['name'] : gameModel.playerTwo!['name']}\'s Turn.. You have to wait a bit! 😥',
                          color: Colors.lightBlue),
                  child: gameTileStat(row, col),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String msg, {Color color = Colors.purpleAccent}) =>
      snackBar(_key, msg, color: color);

  onTap(int r, int c) {
    Map map = gameModel.gameBoard!;
    map['$r,$c'] = widget.playerCode;
    toggleActivePlayer(map as Map<String,dynamic>);
    checkWinner(playingBoard  as List<List<int>>, 0, 1);
  }

  toggleActivePlayer(Map<String, dynamic> map, {bool draw = false}) {
    roomRef.doc(gameModel.roomID).update({
      'active': draw ? gameModel.active : gameModel.active == 0 ? 1 : 0,
      'gameBoard': map,
      'move': draw ? 0 : gameModel.move! + 1,
    });
  }

  gameTileStat(int row, int col) {
    List<List<int>> list = playingBoard as List<List<int>>;

    if (list[row][col] == 0)
      return CircleCross(circle: true);
    else if (list[row][col] == 1)
      return CircleCross(circle: false);
    else
      return Container();
  }

  int checkWinner(List<List<int>> b, int player, int opponent) {
    // Checking for Rows for X or O victory.
    for (int row = 0; row < 3; row++) {
      if (b[row][0] == b[row][1] && b[row][1] == b[row][2]) {
        if (b[row][0] != -1) {
          if (b[row][0] == player)
            showWinner(row, 10);
          else
            showWinner(row, -10);
          return 10;
        }
      }
    }

    // Checking for Columns for X or O victory.
    for (int col = 0; col < 3; col++) {
      if (b[0][col] == b[1][col] && b[1][col] == b[2][col]) {
        if (b[0][col] != -1) {
          if (b[0][col] == player)
            showWinner(col + 3, 10);
          else
            showWinner(col + 3, opponent);
          return 10;
        }
      }
    }

    // Checking for Diagonals for X or O victory.
    if (b[0][0] == b[1][1] && b[1][1] == b[2][2]) {
      if (b[0][0] != -1) {
        if (b[0][0] == player)
          showWinner(6, 10);
        else
          showWinner(6, -10);
        return 10;
      }
    }

    if (b[0][2] == b[1][1] && b[1][1] == b[2][0]) {
      if (b[0][2] != -1) {
        if (b[0][2] == player)
          showWinner(7, 10);
        else
          showWinner(7, -10);
        return 10;
      }
    }

    if (gameModel.move == 8) {
      games++;
      showMessage('Game Draw!!!');
      Future.delayed(Duration(milliseconds: 500), () {
        toggleActivePlayer(freshGameBoard, draw: true);
      });
      return 10;
    }

    return 0;
  }

  showWinner(int state, int winner) {
    String name;
    Map map = gameModel.stats!;
    int active = 0;

    if (winner == 10) {
      name = gameModel.playerOne!['name'];
      map['playerOne'] += 1;
      active = 0;
    } else {
      name = gameModel.playerTwo!['name'];
      map['playerTwo'] += 1;
      active = 1;
    }
    snackBar(_key, '$name wins the match! ✨🥇',
        color: accentColor, seconds: 3000);

    roomRef.doc(gameModel.roomID).update({
      'active': active,
      'winningState': state,
      'stats': map,
      'status': 400,
      'move': 0,
      'winner': name
    });

    Future.delayed(Duration(seconds: 3), () {
      roomRef.doc(gameModel.roomID).update({
        'winningState': -1,
        'status': 200,
        'gameBoard': freshGameBoard,
        'winner': ''
      });
    });
    games++;
  }

  bottomBar() {
    if (gameModel.messages!.isEmpty) {
      return messageCard('Start conversation', false);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: gameModel.messages!.length,
      itemBuilder: (context, index) =>
          messageCard(gameModel.messages!.reversed.toList()[index], true),
    );
  }

  options() {
    return Container(
      height: 55,
      child: Row(
        children: [
          SizedBox(
            width: width(context) * 0.18,
            child: Button(
              color: Colors.redAccent,
              icon: true,
              iconData: FontAwesomeIcons.times,
              onPressed: () => cancelGameDialog(),
            ),
          ),
          SizedBox(width: 6),
          gameModel.status != 404
              ? Expanded(
                  child: Button(
                    color: Colors.green,
                    text: 'Send Message',
                    onPressed: () => sendMessageDialog(),
                  ),
                )
              : Expanded(
                  child: Button(
                    color: Colors.redAccent,
                    text: 'Player Left!',
                    onPressed: () {},
                  ),
                ),
          SizedBox(width: 6),
          SizedBox(
            width: width(context) * 0.18,
            child: Button(
              color: Colors.purpleAccent,
              icon: true,
              iconData: FontAwesomeIcons.solidSmileBeam,
              onPressed: () => showEmojiDialog(),
            ),
          ),
        ],
      ),
    );
  }

  playerProfile(int i) {
    String photoUrl = i == 0
        ? gameModel.playerOne!['photoUrl']
        : gameModel.playerTwo!['photoUrl'];
    String emoji = i == 0 ? gameModel.emojiPlayerOne! : gameModel.emojiPlayerTwo!;
    String name =
        i == 0 ? gameModel.playerOne!['name'] : gameModel.playerTwo!['name'];
    bool activePlayer = i == gameModel.active;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activePlayer ? crossColor : Colors.blueGrey,
            boxShadow: activePlayer
                ? [
                    BoxShadow(
                      color: crossColor,
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: circleColor.withOpacity(0.4),
                radius: width(context) * 0.10,
                backgroundImage: NetworkImage(photoUrl),
              ),
              Positioned(
                bottom: 0,
                right: -2,
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 2)],
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          name,
          style: GoogleFonts.stylish(
            color: activePlayer ? crossColor : Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            letterSpacing: 1.1,
          ),
        )
      ],
    );
  }

  scoreStyle(int i) {
    int scorePlayerOne = gameModel.stats!['playerOne'];
    int scorePlayerTwo = gameModel.stats!['playerTwo'];
    bool active = i == gameModel.active;

    return TextSpan(
      text: i == 0 ? '$scorePlayerOne' : '$scorePlayerTwo',
      style: TextStyle(
        color: active ? Colors.black : Colors.blueGrey,
        decoration: active ? TextDecoration.underline : TextDecoration.none,
        decorationStyle: TextDecorationStyle.wavy,
        decorationThickness: 3,
      ),
    );
  }

  Card messageCard(String message, bool condition) {
    bool currentPlayer = true;
    String urlPlayerOne, urlPlayerTwo;
    if (condition)
      currentPlayer = message.endsWith(widget.playerCode.toString());

    urlPlayerOne = widget.playerCode == 0
        ? gameModel.playerOne!['photoUrl']
        : gameModel.playerTwo!['photoUrl'];

    urlPlayerTwo = widget.playerCode == 1
        ? gameModel.playerOne!['photoUrl']
        : gameModel.playerTwo!['photoUrl'];

    return Card(
      shadowColor: crossColor.withBlue(150).withOpacity(0.7),
      color: crossColor.withBlue(150),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: currentPlayer
            ? CircleAvatar(backgroundImage: NetworkImage(urlPlayerOne))
            : null,
        title: Text(
          condition ? message.substring(0, message.length - 1) : message,
          style: GoogleFonts.stylish(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        trailing: !currentPlayer
            ? CircleAvatar(backgroundImage: NetworkImage(urlPlayerTwo))
            : null,
      ),
    );
  }

  sendMessageDialog() {
    List<dynamic> messages = gameModel.messages!;

    return showModal(
      context: context,
      configuration:
          FadeScaleTransitionConfiguration(barrierDismissible: false),
      builder: (context) => AlertDialog(
        content: Container(
          child: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              validator: (value) =>
                  value!.trim().isEmpty ? 'Please type your message...' : null,
              onSaved: (newValue) =>
                  textEditingController.text = newValue!.trim(),
              controller: textEditingController,
              style: TextStyle(fontWeight: FontWeight.w700),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Enter message',
                hintText: 'Enter your message here...',
                icon: FaIcon(FontAwesomeIcons.reply),
              ),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            textColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
          MaterialButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                messages.add(
                    textEditingController.text + widget.playerCode.toString());
                roomRef
                    .doc(gameModel.roomID)
                    .update({'messages': messages}).then((value) {
                  textEditingController.clear();
                  Navigator.pop(context);
                });
              }
            },
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text('Send'),
            color: accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  showEmojiDialog() {
    return showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 400)),
      builder: (context) => SimpleDialog(
        title: 'Choose an emoji'.style(color: accentColor, fontSize: 20.sp),
        children: [
          Row(
            children: [emojiOption('⭐'), emojiOption('😂'), emojiOption('🙄')],
          ),
          Row(
            children: [emojiOption('😥'), emojiOption('😮'), emojiOption('😫')],
          ),
          Row(
            children: [emojiOption('👊'), emojiOption('😍'), emojiOption('🧨')],
          ),
        ],
      ),
    );
  }

  emojiOption(String text) {
    return Expanded(
      child: SimpleDialogOption(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 30.sp, color: Colors.black),
          ),
        ),
        onPressed: () {
          String metaData =
              widget.playerCode == 0 ? 'emojiPlayerTwo' : 'emojiPlayerOne';
          roomRef
              .doc(gameModel.roomID)
              .update({metaData: text}).then((value) => pop(context));
        },
      ),
    );
  }

  cancelGameDialog() {
    return showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 400)),
      builder: (context) => CustomSimpleDialog(
        title: 'Are you sure to exit the game?',
        actions: [
          [
            'Yes',
            () {
              roomRef.doc(gameModel.roomID).update({'status': 404});

              pushReplaced(context, MainScreen());
            },
            Colors.redAccent
          ],
          ['NO', () => pop(context), accentColor]
        ],
      ),
    );
  }

  List get playingBoard {
    if (gameModel.gameBoard!.isNotEmpty)
      gameModel.gameBoard!.forEach((key, value) {
        List data = key.toString().split(',');
        int row = int.parse(data.first);
        int col = int.parse(data.last);
        _list[row][col] = value;
      });

    return _list;
  }

  Map<String, dynamic> get freshGameBoard => <String, dynamic>{
        '0,0': -1,
        '0,1': -1,
        '0,2': -1,
        '1,0': -1,
        '1,1': -1,
        '1,2': -1,
        '2,0': -1,
        '2,1': -1,
        '2,2': -1
      };
}
