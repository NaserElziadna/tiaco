import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OnlineGameModel extends ChangeNotifier {
  final int? winningState, active, status, move;
  final String? roomID, emojiPlayerOne, emojiPlayerTwo, winner;
  final Map? playerOne, playerTwo, stats, gameBoard;
  final List? messages;

  OnlineGameModel(
      {this.roomID,
      this.playerOne,
      this.playerTwo,
      this.emojiPlayerOne,
      this.emojiPlayerTwo,
      this.move,
      this.winner,
      this.gameBoard,
      this.messages,
      this.status,
      this.winningState,
      this.active,
      this.stats});

  factory OnlineGameModel.fromDoc(DocumentSnapshot doc) => OnlineGameModel(
      roomID: doc.get('roomID'),
      playerOne: doc.get('playerOne'),
      playerTwo: doc.get('playerTwo'),
      emojiPlayerOne: doc.get('emojiPlayerOne') ?? '',
      emojiPlayerTwo: doc.get('emojiPlayerTwo') ?? '',
      gameBoard: doc.get('gameBoard'),
      messages: doc.get('messages'),
      winningState: doc.get('winningState'),
      active: doc.get('active'),
      move: doc.get('move'),
      winner: doc.get('winner'),
      status: doc.get('status'),
      stats: doc.get('stats'));

  Map<String, dynamic> toMap() => <String, dynamic>{
        'roomID': roomID,
        'winner': winner,
        'playerOne': playerOne,
        'move': move,
        'playerTwo': playerTwo,
        'gameBoard': gameBoard,
        'emojiPlayerOne': emojiPlayerOne,
        'emojiPlayerTwo': emojiPlayerTwo,
        'messages': messages,
        'stats': stats,
        'active': active,
        'status': status,
        'winningState': winningState
      };
}