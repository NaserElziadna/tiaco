import 'package:audioplayers/audioplayers.dart';

class SoundService {
  AudioPlayer? _audioPlayer;
  AudioCache? _audioCache;

  SoundService() {
    _audioPlayer = AudioPlayer(playerId: "12345678");
    _audioCache = AudioCache();
    _audioCache!.loadAll(['o.mp3', 'x.mp3', 'click.mp3']);
  }

  playSound(String sound) async {
    
    _audioPlayer!.play(AssetSource("$sound.mp3"));
  }
}