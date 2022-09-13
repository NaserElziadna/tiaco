import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/single_player.dart';
import 'package:tictactoe/src/theme/routes.dart';

class PlayerName extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
            labelText: 'Enter Friend Name',
            hintText: 'Enter your friend\'s name'),
        style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1),
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.words,
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 15),
      actions: [
        MaterialButton(
          onPressed: () => pop(context),
          child: Text('Close'),
          textColor: Colors.red,
        ),
        MaterialButton(
          onPressed: () async {
            Provider.of<GameProvider>(context, listen: false).muliReset();
            bool value = Provider.of<GameProvider>(context, listen: false)
                .setGameMode(GAME_MODE.MULTI, textEditingController.text,
                    GAME_DIFFICULITY.EASY);

            pop(context);
            if (value) push(context, SinglePlayer());
          },
          child: Text('Continue'),
          textColor: Colors.teal,
        )
      ],
    );
  }
}
