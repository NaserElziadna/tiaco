import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/single_player.dart';
import 'package:tictactoe/src/theme/routes.dart';

class DifficultyChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Choose difficulty'),
      children: [
        SimpleDialogOption(
          child: text('Easy', Colors.teal),
          onPressed: () => onTap(context, GAME_DIFFICULITY.EASY),
        ),
        SimpleDialogOption(
          child: Center(child: text('Medium', Colors.orange)),
          onPressed: () => onTap(context, GAME_DIFFICULITY.MEDIUM),
        ),
        SimpleDialogOption(
          child: Center(child: text('Expert', Colors.redAccent)),
          onPressed: () => onTap(context, GAME_DIFFICULITY.EXPERT),
        ),
      ],
    );
  }

  onTap(BuildContext context, GAME_DIFFICULITY game) {
    pop(context);
    bool value = Provider.of<GameProvider>(context, listen: false)
        .setGameMode(GAME_MODE.SINGLE, '', game);
    if (value) push(context, SinglePlayer());
  }

  text(String text, Color color) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.stylish(
            color: color, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}