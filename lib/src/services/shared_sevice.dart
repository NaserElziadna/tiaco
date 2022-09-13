// import 'package:play_games/play_games.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/src/services/game_provider.dart';

class SharedService {
  static SharedPreferences? sharedPreferences;
  static const String _STREAK = 'streak',
      _FIRST_TIME = 'firstTime',
      _NAME = 'name',
     _BUCKS = 'bucks',
      _PHOTO_URL = 'photoUrl',
      _UID = 'uid',
      _ISONLINE = 'isOnline',
      _PLAY = 'playGames';

  Future<SharedPreferences> initialize() async {
    if (sharedPreferences != null)
      return sharedPreferences!;
    else
      return await SharedPreferences.getInstance();
  }

  Future<String> get photoUrl async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getString(_PHOTO_URL) ?? '';
  }

  Future<bool> setPhotoUrl(String url) async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setString(_PHOTO_URL, url);
  }

    Future<bool> get isOnline async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getBool(_ISONLINE) ?? false;
  }

  Future<bool> setIsOnline(bool isOnline) async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setBool(_ISONLINE , isOnline);
  }

  Future<bool> setBucks(int value, {bool deduct = false}) async {
    sharedPreferences = await initialize();
    int val = await bucks;
    return sharedPreferences!.setInt(_BUCKS, deduct ? val - value : val + value);
  }

  Future<int> get bucks async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getInt(_BUCKS) ?? 0;
  }

  Future<String> get userName async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getString(_NAME) ?? '';
  }

  Future<bool> setUserName(String value) async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setString(_NAME, value);
  }

  Future<bool> get firstTime async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getBool(_FIRST_TIME) ?? false;
  }

  Future<bool> setFirstTime() async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setBool(_FIRST_TIME, true);
  }

  Future<int> get streak async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getInt(_STREAK) ?? 0;
  }

  Future<bool> updateStreak(int data) async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setInt(_STREAK, data);
  }

  Future<String?> get uid async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getString(_UID);
  }

  Future<bool> setUid(String id) async {
    sharedPreferences = await initialize();
    return sharedPreferences!.setString(_UID, id);
  }

  Future<bool> get playGames async {
    sharedPreferences = await initialize();
    return sharedPreferences!.getBool(_PLAY) ?? false;
  }

  Future<bool> setPlayGames(GameProvider value) async {
    sharedPreferences = await initialize();

    //TODO::Update google game play || game services

    // int _easy = value.singlePlayer.wins +
    //         value.singlePlayer.losses +
    //         value.singlePlayer.draws,
    //     _medium = value.singlePlayerMedium.wins +
    //         value.singlePlayerMedium.losses +
    //         value.singlePlayerMedium.draws,
    //     _expert = value.singlePlayerExpert.wins +
    //         value.singlePlayerExpert.losses +
    //         value.singlePlayerExpert.draws;

    // // Easy
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQAg", _easy);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBQ", _easy);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQCw", _easy);

    // // Medium
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQAw", _medium);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBg", _medium);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQDA", _medium);

    // // Expert
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBA", _expert);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQBw", _expert);
    // PlayGames.incrementAchievementById("CgkIoajzqOMJEAIQDQ", _expert);

    return sharedPreferences!.setBool(_PLAY, true);
  }
}