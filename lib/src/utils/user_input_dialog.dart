import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tictactoe/src/main_screen.dart';
import 'package:tictactoe/src/models/game_stat.dart';
import 'package:tictactoe/src/services/db_service.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';

class UserInputDialog extends StatefulWidget {
  @override
  _UserInputDialogState createState() => _UserInputDialogState();
}

class _UserInputDialogState extends State<UserInputDialog> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  submit(BuildContext context) async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();

      SharedService service = SharedService();

      await service.setUserName(textEditingController.text);
      await service.setFirstTime();
      await service.setBucks(100);

      DBService dbService = DBService();
      await dbService
          .insert(GameStat(data: 'single', wins: 0, losses: 0, draws: 0));
      await dbService
          .insert(GameStat(data: 'multi', wins: 0, losses: 0, draws: 0));
      await dbService.insert(
          GameStat(data: 'single_medium', wins: 0, losses: 0, draws: 0));
      await dbService.insert(
          GameStat(data: 'single_expert', wins: 0, losses: 0, draws: 0));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set up your profile'),
      scrollable: true,
      content: Form(
        key: _key,
        child: TextFormField(
          controller: textEditingController,
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter your name' : null,
          decoration: InputDecoration(
            labelText: 'Enter Name',
            hintText: 'Enter your name',
            icon: FaIcon(FontAwesomeIcons.user),
          ),
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1),
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 15),
      actions: [
        MaterialButton(
          onPressed: () => submit(context),
          child: Text('Continue'),
          textColor: Colors.teal,
        )
      ],
    );
  }
}
