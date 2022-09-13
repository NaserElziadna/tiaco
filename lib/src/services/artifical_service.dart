import 'dart:math';

import 'package:tictactoe/src/services/game_provider.dart';

abstract class ArtificialService {
  List<int> getMove(List<List<AVATAR>> gameBoard);
  var scores = {AVATAR.X: 1, AVATAR.O: -1, AVATAR.BLANK: 0};

  List<List<int>> getEmptyCells(List<List<AVATAR>> gameBoard) {
    List<List<int>> emptyCells = <List<int>>[];
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        if (gameBoard[i][j] == AVATAR.BLANK) emptyCells.add([i, j]);

    return emptyCells;
  }

  List<int> randomMove(List<List<AVATAR>> gameBoard) {
    List<List<int>> emptyCells = getEmptyCells(gameBoard);
    Random random = Random();
    int index = random.nextInt(emptyCells.length);
    return emptyCells[index];
  }

  num minimax(List<List<AVATAR>> gameBoard, int depth, bool isMaximize) {
    int score = evaluate(gameBoard, AVATAR.X, AVATAR.O);

    if (score == 10) return score;
    if (score == -10) return score;
    if (getEmptyCells(gameBoard).length == 0) return 0;

    if (isMaximize) {
      num bestScore = -1000;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (gameBoard[i][j] == AVATAR.BLANK) {
            gameBoard[i][j] = AVATAR.X;
            num score = minimax(gameBoard, depth + 1, false);
            bestScore = max(score, bestScore);
            gameBoard[i][j] = AVATAR.BLANK;
          }
        }
      }
      return bestScore;
    } else {
      num bestScore = 1000;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (gameBoard[i][j] == AVATAR.BLANK) {
            gameBoard[i][j] = AVATAR.O;
            num score = minimax(gameBoard, depth + 1, true);
            bestScore = min(score, bestScore);
            gameBoard[i][j] = AVATAR.BLANK;
          }
        }
      }
      return bestScore;
    }
  }

  int evaluate(List<List<AVATAR>> b, AVATAR player, opponent) {
    // Checking for Rows for X or O victory.
    for (int row = 0; row < 3; row++) {
      if (b[row][0] == b[row][1] && b[row][1] == b[row][2]) {
        if (b[row][0] == player)
          return 10;
        else if (b[row][0] == opponent) return -10;
      }
    }

    // Checking for Columns for X or O victory.
    for (int col = 0; col < 3; col++) {
      if (b[0][col] == b[1][col] && b[1][col] == b[2][col]) {
        if (b[0][col] == player)
          return 10;
        else if (b[0][col] == opponent) return -10;
      }
    }

    // Checking for Diagonals for X or O victory.
    if (b[0][0] == b[1][1] && b[1][1] == b[2][2]) {
      if (b[0][0] == player)
        return 10;
      else if (b[0][0] == opponent) return -10;
    }

    if (b[0][2] == b[1][1] && b[1][1] == b[2][0]) {
      if (b[0][2] == player)
        return 10;
      else if (b[0][2] == opponent) return -10;
    }

    return 0;
  }
}