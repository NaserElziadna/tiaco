import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tictactoe/src/constants.dart';
import 'package:tictactoe/src/models/online_game_model.dart';
import 'package:tictactoe/src/models/pending_game_model.dart';
import 'package:tictactoe/src/models/user_model.dart';
import 'package:tictactoe/src/online_game.dart';
//import 'package:tictactoe/src/services/admob_service.dart';
import 'package:tictactoe/src/services/database_service.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/theme/routes.dart';
import 'package:tictactoe/src/utils/button.dart';
import 'text_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateRoomDialog extends StatefulWidget {
  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  String? uid, code = '';
  int coins = 0;
  bool created = false, found = false, joining = false, joined = false;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  GlobalKey _key = GlobalKey();
//  AdMobService adMobService = AdMobService();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    uid = await SharedService().uid;
    coins = await SharedService().bucks;
//    adMobService.rewarded
//      ..load(
//          adUnitId: AdMobService.VIDEO,
//          targetingInfo: AdMobService.targetingInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: BackButton(color: Colors.black, onPressed: () => pop(context)),
        elevation: 0.0,
        centerTitle: true,
        title: 'Online Multiplayer'.style(color: Colors.black, fontSize: 20.sp),
        backgroundColor: Colors.white,
      ),
      body: RepaintBoundary(
        key: _key,
        child: Container(
          height: height(context),
          width: width(context),
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/logo.png'),
                radius: width(context) * (joining || joined ? 0.28 : 0.40),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) =>
                      FadeScaleTransition(animation: animation, child: child),
                  child: child(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  child() {
    if (!created && !joining && !joined)
      return roomInit();
    else if (created && !joining)
      return roomCreated(_key);
    else if (joined)
      return roomJoined(textEditingController.text);
    else
      return joinRoom();
  }

//  checkCoins(bool create) {
//    showModal(
//      context: context,
//      builder: (context) => AlertDialog(
//        scrollable: true,
//        title: Text('Entry Fees'),
//        content: Column(
//          children: [
//            'You have $coins coins!'.style(fontSize: 25.sp, color: crossColor),
//            SizedBox(height: 10),
//            Button(
//              text: 'Spend 50 Coins',
//              color: coins >= 50 ? accentColor : Colors.blueGrey,
//              onPressed: coins >= 50
//                  ? () {
//                      SharedService().setBucks(50, deduct: true);
//                      if (create) {
//                        pendingRef.document(uid.substring(0, 5)).setData(
//                            {'status': 100, 'id': uid, 'secondID': ''});
//                        created = true;
//                      } else {
//                        joining = true;
//                      }
//                      setState(() {});
//                      pop(context);
//                    }
//                  : null,
//            ),
//            Padding(
//              padding: EdgeInsets.all(10),
//              child: 'OR'.style(),
//            ),
//            Button(
//              text: 'Watch an ad',
//              color: Colors.redAccent,
//              onPressed: () {
//                adMobService.rewarded.listener = (RewardedVideoAdEvent event,
//                    {String rewardType, int rewardAmount}) {
//                  if (event == RewardedVideoAdEvent.rewarded ||
//                      event == RewardedVideoAdEvent.completed) {
//                    if (create) {
//                      pendingRef
//                          .document(uid.substring(0, 5))
//                          .setData({'status': 100, 'id': uid, 'secondID': ''});
//                      setState(() {
//                        created = true;
//                      });
//                    } else {
//                      setState(() {
//                        joining = true;
//                      });
//                    }
//                  }
//                };
//
//                adMobService.rewarded
//                    .load(
//                  adUnitId: AdMobService.VIDEO,
//                  targetingInfo: AdMobService.targetingInfo,
//                )
//                    .then((value) {
//                  if (value)
//                    adMobService.rewarded.show().then((value) {
//                      if (value) pop(context);
//                    });
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  roomInit() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            child: Button(
              color: accentColor,
              onPressed: () {
                pendingRef
                    .doc(uid!.substring(0, 5))
                    .set({'status': 100, 'id': uid, 'secondID': ''});
                setState(() {
                  created = true;
                });
//                checkCoins(true);
              },
              text: 'Create room',
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 60,
            child: Button(
              color: crossColor,
              onPressed: () => this.setState(() {
                joining = true;
              }),
              text: 'Join room',
            ),
          ),
        ],
      ),
    );
  }

  joinRoom() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          !found
              ? Form(
                  child: TextFormField(
                    autofocus: true,
                    controller: textEditingController,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.stylish(fontSize: 20.sp),
                    decoration: InputDecoration(
                        labelText: 'Enter Code',
                        hintText: 'Enter your code here...'),
                  ),
                )
              : Container(),
          SizedBox(
            height: 55,
            child: Button(
              color: accentColor,
              onPressed: () async {
                if (textEditingController.text.isNotEmpty) {
                  DocumentSnapshot documentSnapshot =
                      await pendingRef.doc(textEditingController.text).get();
                  if (documentSnapshot.exists) {
                    snackBar(_globalKey,
                        'Room Found!!! He / She will start the game. ⭐');
                    pendingRef
                        .doc(textEditingController.text)
                        .update({'status': 200, 'secondID': uid});

                    setState(() {
                      joining = false;
                      joined = true;
                    });
                  } else {
                    snackBar(_globalKey, 'Room Not Found!!! Try Again 😥',
                        color: Colors.redAccent);
                  }
                }
              },
              text: 'Check',
            ),
          )
        ],
      ),
    );
  }

  roomCreated(GlobalKey _key) {
    return StreamProvider<PendingGameModel>.value(
      initialData: PendingGameModel(),
      value: DatabaseService(id: uid!.substring(0, 5)).pendingRoom,
      builder: (context, child) => CreatedRoom(_key),
    );
  }

  roomJoined(String code) {
    return StreamProvider<PendingGameModel>.value(
      initialData: PendingGameModel(),
      value: DatabaseService(id: code).pendingRoom,
      builder: (context, child) => JoinedRoom(code),
    );
  }
}

class JoinedRoom extends StatefulWidget {
  final String code;

  JoinedRoom(this.code);

  @override
  _JoinedRoomState createState() => _JoinedRoomState();
}

class _JoinedRoomState extends State<JoinedRoom> {
  @override
  Widget build(BuildContext context) {
    PendingGameModel pendingGameModel = Provider.of<PendingGameModel>(context);

    return pendingGameModel != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              '${pendingGameModel.id == null ? 'null id' : pendingGameModel.id!.substring(0, 5)}: Room Code!'
                  .style(fontSize: 25.sp, color: crossColor),
              SizedBox(height: 15),
              FutureBuilder(
                future: userRef.doc(pendingGameModel.id).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  UserModel userModel =
                      UserModel.fromDoc(snapshot.data as DocumentSnapshot);

                  return ListTile(
                    title: pendingGameModel.status != 300
                        ? '${userModel.name} will start the game!'
                            .style(fontSize: 18.sp, color: Colors.blueGrey)
                        : '${userModel.name} has started the game!'
                            .style(fontSize: 18.sp, color: Colors.blueGrey),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(userModel.photoUrl!),
                        radius: 25),
                  );
                },
              ),
              SizedBox(height: 15),
              if (pendingGameModel.status == 300) ...[
                'Click on Start Button!!!'
                    .style(fontSize: 20.sp, color: accentColor),
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: Button(
                    text: 'Start',
                    color: crossColor,
                    onPressed: () => onTap(pendingGameModel),
                  ),
                )
              ]
            ],
          )
        : Container();
  }

  onTap(PendingGameModel pendingGameModel) async {
    String roomID = pendingGameModel.id!.substring(0, 5) +
        '-' +
        pendingGameModel.secondID!.substring(0, 5);
    pushReplaced(context, OnlineGame(roomID, 1));
  }
}

class CreatedRoom extends StatefulWidget {
  final GlobalKey repaintKey;

  CreatedRoom(this.repaintKey);

  @override
  _CreatedRoomState createState() => _CreatedRoomState();
}

class _CreatedRoomState extends State<CreatedRoom> {
  @override
  Widget build(BuildContext context) {
    PendingGameModel pendingGameModel = Provider.of<PendingGameModel>(context);

    return pendingGameModel != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              'Room has been successfully created!'
                  .style(fontSize: 20.sp, color: Colors.blueGrey),
              SizedBox(height: 5),
              'Share this code with your friend'
                  .style(color: accentColor, fontSize: 19.sp),
              SizedBox(height: 5),
              pendingGameModel.secondID != null &&
                      pendingGameModel.secondID!.isNotEmpty
                  ? FutureBuilder(
                      future: userRef.doc(pendingGameModel.secondID).get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();

                        UserModel userModel = UserModel.fromDoc(snapshot.data!);

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: '${userModel.name} has challenged you!'
                                .style(fontSize: 18.sp, color: Colors.blueGrey),
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userModel.photoUrl!),
                                radius: 25),
                          ),
                        );
                      },
                    )
                  : '\n${pendingGameModel.id == null ? '' : pendingGameModel.id!.substring(0, 5)}\n'
                      .style(color: Colors.black, fontSize: 30.sp),
              SizedBox(height: 10),
              SizedBox(
                height: 55,
                child: Button(
                  color: pendingGameModel.status != 200
                      ? Colors.teal
                      : accentColor,
                  onPressed: () {
                    if (pendingGameModel.status != 200) {
                      share(pendingGameModel);
                    } else {
                      onTap(pendingGameModel);
                    }
                  },
                  text: pendingGameModel.status != 200 ? 'Share' : 'Start',
                ),
              )
            ],
          )
        : Container();
  }

  share(PendingGameModel pendingGameModel) async {
    // print("share is not working {create room dialog file}");
    String text =
        'I am challenging you for a Tic Tac Toe match!\nPlease install it from here: https://play.google.com/store/apps/details?id=com.anmolsethi.tictactoe\n\nStart Game and Go to Online Multiplayer Mode, Click on Join Room and Enter Room Code: "${pendingGameModel.id!.substring(0, 5)}".\nStart Playing!';
    File file =
        File('/data/user/0/com.nmmsoft.tictactoe/app_flutter/image.png');

    if (!file.existsSync()) {
      RenderRepaintBoundary renderRepaintBoundary =
          widget.repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
      ByteData? byteData =
          await boxImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8list = byteData!.buffer.asUint8List();
      file.writeAsBytesSync(uint8list);
    }
    //TODO: share method
    var userName = await SharedService().userName;
    var code = await SharedService().uid;
    Share.shareFiles(
      ['${file.path}'],
      subject: 'Tic Tac Toe: Online Multiplayer',
      text: '${userName} is Challenging you ♥ ☺ ☻ // Code is : ${code!.substring(0,5)}',
      // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );

    // await Share.file('Tic Tac Toe: Online Multiplayer', 'code.png',
    //     file.readAsBytesSync(), 'image/png',
    //     text: text);
  }

  onTap(PendingGameModel pendingGameModel) async {
    UserModel? playerOne = await DatabaseService.user;
    UserModel playerTwo =
        UserModel.fromDoc((await userRef.doc(pendingGameModel.secondID).get()));

    String roomID = pendingGameModel.id!.substring(0, 5) +
        '-' +
        pendingGameModel.secondID!.substring(0, 5);

    OnlineGameModel game = OnlineGameModel(
        active: 0,
        roomID: roomID,
        playerOne: playerOne!.toMap(),
        playerTwo: playerTwo.toMap(),
        messages: <String>[],
        stats: {'playerOne': 0, 'playerTwo': 0},
        winningState: -1,
        status: 200,
        move: 0,
        gameBoard: {
          '0,0': -1,
          '0,1': -1,
          '0,2': -1,
          '1,0': -1,
          '1,1': -1,
          '1,2': -1,
          '2,0': -1,
          '2,1': -1,
          '2,2': -1
        },
        emojiPlayerOne: '',
        emojiPlayerTwo: '',
        winner: '');

    bool val = await DatabaseService().createRoom(game);

    if (val) {
      pendingRef
          .doc(pendingGameModel.id!.substring(0, 5))
          .update({'status': 300});
      pushReplaced(context, OnlineGame(game.roomID!, 0));
    }
  }
}
