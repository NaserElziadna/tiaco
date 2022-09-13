import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/starting_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // "No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()"
  await Firebase.initializeApp();
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameProvider>(
      create: (context) => GameProvider(context: context),
      builder: (context, child) => MaterialApp(
        title: 'Tic Tac Toe Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          platform: TargetPlatform.android,
        ),
        home: StartingScreen(),
      ),
    );
  }
}
