import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:tictactoe/src/components/circle_cross.dart';
import 'package:tictactoe/src/models/game_stat.dart';
import 'package:tictactoe/src/services/auto_play_service.dart';
import 'package:tictactoe/src/services/db_service.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';
import 'package:tictactoe/src/services/sound_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'package:tictactoe/src/utils/show_winner_dialog.dart';
import 'package:tictactoe/src/utils/text_data.dart';

class GameProvider extends ChangeNotifier {
  final String? _photoUrl =
      '/data/user/0/com.nmmsoft.tictactoe/app_flutter/photoUrl.jpg';

  late GlobalKey<ScaffoldState> _key;
  late SharedService service = SharedService();
  late SoundService soundService = SoundService();
  late DBService dbService = DBService();
  late GAME_MODE _gameMode = GAME_MODE.SINGLE;
  late GAME_DIFFICULITY _gameDifficulity = GAME_DIFFICULITY.EASY;
  late AnimationController _animationController;

  late String _name = "player", _playerName;
  late int _bucks=0,
      _streak,
      _currentStreak = 0,
      _moveCount = 0,
      _wins = 0,
      _losses = 0,
      _draws = 0,
      _winningState = -1,
      _games = 0;
  List<GameStat> listGameStat = <GameStat>[];
  AVATAR avatar = AVATAR.O, activePlayer = AVATAR.O, winner = AVATAR.BLANK;
  BuildContext? context;

  List<List<AVATAR>> game = List<List<AVATAR>>.generate(
    3,
    (i) => List<AVATAR>.generate(3, (j) => AVATAR.BLANK),
  );

  set setContext(BuildContext ctx) => this.context = ctx;
  set key(GlobalKey<ScaffoldState> key) => this._key = key;
  set difficulty(GAME_DIFFICULITY gameDif) => this._gameDifficulity = gameDif;
  set animation(AnimationController animationController) =>
      this._animationController = animationController;

  String get name => this._name;
  String get photoUrl => this._photoUrl!;
  String get playerName => this._playerName;

  int get bucks => this._bucks;
  int get streak => this._streak;
  int get currentStreak => this._currentStreak;
  int get wins => this._wins;
  int get losses => this._losses;
  int get draws => this._draws;
  int get winningState => this._winningState;
  int get noOfGames => _games;

  GameStat get singlePlayer => listGameStat[0];
  GameStat get multiPlayer => listGameStat[1];
  GameStat get singlePlayerMedium => listGameStat[2];
  GameStat get singlePlayerExpert => listGameStat[3];

  GAME_MODE get gameMode => this._gameMode;

  GAME_DIFFICULITY get gameDifficulty => this._gameDifficulity;

  bool get singlyGame => this._gameMode == GAME_MODE.SINGLE;
  bool get userIsActivePlayer => this.activePlayer == this.avatar;

  GameProvider({this.context}) {
    init();
  }

  Future<bool> init() async {
    try {
      _name = await service.userName;
      _bucks = await service.bucks;
      _streak = await service.streak;

      List<GameStat> list = await dbService.getStats();
      if (list.length == 0) {
        await dbService
            .insert(GameStat(data: 'single', wins: 0, losses: 0, draws: 0));
        await dbService
            .insert(GameStat(data: 'multi', wins: 0, losses: 0, draws: 0));
        await dbService.insert(
            GameStat(data: 'single_medium', wins: 0, losses: 0, draws: 0));
        await dbService.insert(
            GameStat(data: 'single_expert', wins: 0, losses: 0, draws: 0));
        listGameStat = await dbService.getStats();
      } else {
        listGameStat = list;
      }
    } catch (e) {
      throw Exception(e);
    }

    notifyListeners();
    return true;
  }

  setWinner(AVATAR win) {
    this.winner = win;
    notifyListeners();
  }

  Widget gameTileButton(int row, int col) {
    return GestureDetector(
      onTap: (singlyGame
              ? game[row][col] == AVATAR.BLANK && userIsActivePlayer
              : game[row][col] == AVATAR.BLANK)
          ? () => gameButtonTap(row, col)
          : () {},
      child: gameTileState(row, col),
    );
  }

  void gameButtonTap(int row, int col) {
    if (activePlayer == AVATAR.O)
      soundService.playSound('o');
    else
      soundService.playSound('x');
    _moveCount++;
    game[row][col] = activePlayer;
    if (!checkWinner(row, col, activePlayer)) return;
    if (singlyGame)
      toggleActivePlayer();
    else
      changeTurn();
    notifyListeners();
  }

  toggleActivePlayer() {
    if (userIsActivePlayer) {
      changeTurn();
      autoPlay();
    } else
      activePlayer = avatar;
  }

  changeTurn() {
    if (activePlayer == AVATAR.O)
      activePlayer = AVATAR.X;
    else
      activePlayer = AVATAR.O;
  }

  void autoPlay() {
    Future.delayed(Duration(milliseconds: 700), () {
      List<int> data = AutoPlay(_gameDifficulity).getMove(game);
      gameButtonTap(data[0], data[1]);
    });
  }

  gameTileState(int row, int col) {
    if (game[row][col] == AVATAR.X)
      return CircleCross(circle: false);
    else if (game[row][col] == AVATAR.O)
      return CircleCross(circle: true);
    else
      return null;
  }

  bool checkWinner(int row, int col, AVATAR ava) {
    for (int i = 0; i < 3; i++) {
      if (game[row][i] != ava) break;
      if (i == 2) {
        this._winningState = row;
        setWinner(ava);
        showMessage();
        showWinner();
        return false;
      }
    }

    for (int i = 0; i < 3; i++) {
      if (game[i][col] != ava) break;
      if (i == 2) {
        this._winningState = col + 3;
        setWinner(ava);
        showMessage();
        showWinner();
        return false;
      }
    }

    if (row == col) {
      for (int i = 0; i < 3; i++) {
        if (game[i][i] != ava) break;
        if (i == 2) {
          this._winningState = 6;
          setWinner(ava);
          showMessage();
          showWinner();
          return false;
        }
      }
    }

    if (row + col == 2) {
      for (int i = 0; i < 3; i++) {
        if (game[i][2 - i] != ava) break;
        if (i == 2) {
          this._winningState = 7;
          setWinner(ava);
          showMessage();
          showWinner();
          return false;
        }
      }
    }

    if (_moveCount == 9) {
      setWinner(AVATAR.BLANK);
      showWinner();
      return false;
    }
    return true;
  }

  showWinner() {
    _animationController.reverse();
    Future.delayed(Duration(milliseconds: 750), () {
      showModal(
        context: this.context!,
        configuration:
            FadeScaleTransitionConfiguration(barrierDismissible: false),
        builder: (ctx) => ShowWinnerDialog(),
      );
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context!);
        updateDatabase().then((value) {
          if (value)
            reset().then((value) {
              if (value) if (singlyGame) if (!userIsActivePlayer) autoPlay();
              _animationController.forward();
            });
        });
      });
    });
  }

  Future<bool> updateDatabase() async {
    GameStat gameStat = listGameStat[getCurrentGameStat()[1]];

    int lWin = gameStat.wins!, lLoss = gameStat.losses!, lDraw = gameStat.draws!;

    if (winner == AVATAR.O) {
      lWin++;
      _currentStreak++;
      _wins++;
      if (singlyGame) {
        service.setBucks(5);
        _bucks = await service.bucks;
      }
    } else if (winner == AVATAR.BLANK) {
      lDraw++;
      _draws++;
    } else {
      lLoss++;
      _losses++;
      _currentStreak = 0;
    }

    // logic();

    GameStat localGameStat = GameStat(
        data: getCurrentGameStat()[0], wins: lWin, losses: lLoss, draws: lDraw);
    await dbService.update(localGameStat);
    listGameStat[getCurrentGameStat()[1]] = localGameStat;
    if (_currentStreak >= _streak) {
      _streak = _currentStreak;
      service.updateStreak(_currentStreak);
    }
    notifyListeners();
    return Future.value(true);
  }

  // logic() async {
  //   if (!await service.playGames)
  //     return;
  //   else {
  //     try {
  //       if (gameDiff() == 0) {
  //         // Easy
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQAg");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBQ");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQCw");
  //       } else if (gameDiff() == 1) {
  //         // Medium
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQAw");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBg");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQDA");
  //       } else {
  //         // Expert
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBA");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBw");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQDQ");
  //       }
  //       if (winner == AVATAR.O) {
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQEQ");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQEg");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQEw");
  //         PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQFA", 5);
  //       }
  //     } catch (e) {}
  //   }
  // }

  boardReset() {
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++) game[i][j] = AVATAR.BLANK;
  }

  Future<bool> reset() {
    _games++;
    _moveCount = 0;
    boardReset();

    if (winner == AVATAR.BLANK)
      changeTurn();
    else
      activePlayer = winner;

    winner = AVATAR.BLANK;
    _winningState = -1;
//    checkAdStatus();
    notifyListeners();
    return Future.value(true);
  }

  List<dynamic> getCurrentGameStat() {
    String data;
    int value;
    if (singlyGame) {
      if (_gameDifficulity == GAME_DIFFICULITY.EASY) {
        data = 'single';
        value = 0;
      } else if (_gameDifficulity == GAME_DIFFICULITY.MEDIUM) {
        data = 'single_medium';
        value = 2;
      } else {
        data = 'single_expert';
        value = 3;
      }
    } else {
      data = 'multi';
      value = 1;
    }

    return [data, value];
  }

  bool setGameMode(
      GAME_MODE gameModeData, String name, GAME_DIFFICULITY gameDifficulity) {
    _gameMode = gameModeData;
    _gameDifficulity = gameDifficulity;
    _playerName = name;
    _moveCount = 0;
    boardReset();

    notifyListeners();
    return true;
  }

  showMessage() {
    String? text;
    Color? color;
    if (winner == AVATAR.O) {
      text = singlyGame
          ? '🥳🏆 You won this round! +5 Coins'
          : '🥳🏆 $_name won this round!';
      color = Colors.green;
    } else if (winner == AVATAR.X) {
      text = singlyGame
          ? '😰🙄 You lost this round!'
          : '🥳🏆 $_playerName won this round!';
      color = Colors.redAccent;
    } else if (winner == AVATAR.BLANK) {
      text = '😮 This game is a draw, try to use your brain!next time';
      color = accentColor;
    }

    snackBar(_key, text!,
        color: singlyGame ? color : Colors.green, seconds: 1800);
  }

  setGameDifficulty(GAME_DIFFICULITY gameDiff) {
    this._gameDifficulity = gameDiff;
    _moveCount = 0;
    boardReset();

    toggleActivePlayer();
    notifyListeners();
  }

  muliReset() {
    this._wins = 0;
    this._losses = 0;
    this._draws = 0;
    this._playerName = '';
    boardReset();
    notifyListeners();
  }

  int gameDiff() {
    if (_gameDifficulity == GAME_DIFFICULITY.EASY)
      return 0;
    else if (_gameDifficulity == GAME_DIFFICULITY.MEDIUM)
      return 1;
    else
      return 2;
  }
}

enum AVATAR { X, O, BLANK }
enum GAME_DIFFICULITY { EASY, MEDIUM, EXPERT }
enum GAME_MODE { SINGLE, MULTI }
