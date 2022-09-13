import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe/src/constants.dart';
import 'package:tictactoe/src/models/online_game_model.dart';
import 'package:tictactoe/src/models/pending_game_model.dart';
import 'package:tictactoe/src/models/user_model.dart';

class DatabaseService {
  final String? roomID, id;

  DatabaseService({this.roomID, this.id});

  static Future<UserModel?> get user => Future.value(UserModel.fromFirebase(FirebaseAuth.instance.currentUser!));
  // static Future<UserModel> get user => FirebaseAuth.instance.currentUser!.then((value) => UserModel.fromFirebase(value));

  Future<bool> createRoom(OnlineGameModel game) async {
    try {
      roomRef.doc(game.roomID).set(game.toMap());
    } catch (e) {
      throw PlatformException(
          code: '1',
          message: 'No Internet Connection!',
          details: 'Error while creating room');
    }
    return true;
  }

  Stream<PendingGameModel> get pendingRoom => pendingRef
      .doc(id)
      .snapshots()
      .map((event) => PendingGameModel.fromDoc(event));

  Stream<OnlineGameModel> get room => roomRef
      .doc(roomID)
      .snapshots()
      .map((event) => OnlineGameModel.fromDoc(event));
}
