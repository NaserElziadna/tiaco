import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/components/circle_cross.dart';
import 'package:tictactoe/src/components/equal.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/theme/prefrences.dart';

class ShowWinnerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, value, child) => AlertDialog(
        scrollable: true,
        title: value.winner != AVATAR.BLANK
            ? value.winner == value.avatar
                ? Text('Woohooo!!! 🥳🥳🏆')
                : value.gameMode == GAME_MODE.SINGLE
                    ? Text('Try Again! 😇✌')
                    : Text('Woohooo!!! 🥳🥳🏆')
            : Text('It\'s a Draw!!! 😱'),
        contentPadding: const EdgeInsets.all(8),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: width(context) * 0.45,
              width: width(context) * 0.45,
              child: value.winner != AVATAR.BLANK
                  ? value.winner == AVATAR.X
                      ? CircleCross(circle: false)
                      : CircleCross(circle: true)
                  : Equal(),
            ),
          ],
        ),
      ),
    );
  }
}
