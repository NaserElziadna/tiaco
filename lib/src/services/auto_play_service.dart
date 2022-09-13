import 'package:tictactoe/src/services/artifical_service.dart';
import 'package:tictactoe/src/services/game_provider.dart';

class AutoPlay extends ArtificialService {
  final GAME_DIFFICULITY gameDifficulity;

  AutoPlay(this.gameDifficulity);

  @override
  List<int> getMove(List<List<AVATAR>> gameBoard) {
    if (this.gameDifficulity == GAME_DIFFICULITY.EASY)
      return AutoPlayEasy().getMove(gameBoard);
    else if (gameDifficulity == GAME_DIFFICULITY.MEDIUM)
      return AutoPlayMedium().getMove(gameBoard);
    else
      return AutoPlayExpert().getMove(gameBoard);
  }
}

class AutoPlayEasy extends ArtificialService {
  @override
  List<int> getMove(List<List<AVATAR>> gameBoard) => randomMove(gameBoard);
}

class AutoPlayMedium extends ArtificialService {
  @override
  List<int> getMove(List<List<AVATAR>> gameBoard) {
    int data = getEmptyCells(gameBoard).length;

    if (data >= 6) return randomMove(gameBoard);

    num bestScore = -1000;
    List<int> bestMove = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameBoard[i][j] == AVATAR.BLANK) {
          gameBoard[i][j] = AVATAR.X;
          num score = minimax(gameBoard, 0, false);
          gameBoard[i][j] = AVATAR.BLANK;

          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }
    return bestMove;
  }
}

class AutoPlayExpert extends ArtificialService {
  @override
  List<int> getMove(List<List<AVATAR>> gameBoard) {
    if (getEmptyCells(gameBoard).length == 9) return randomMove(gameBoard);

    num bestScore = -1000;
    List<int> bestMove = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameBoard[i][j] == AVATAR.BLANK) {
          gameBoard[i][j] = AVATAR.X;
          num score = minimax(gameBoard, 0, false);
          gameBoard[i][j] = AVATAR.BLANK;

          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }
    return bestMove;
  }
}
