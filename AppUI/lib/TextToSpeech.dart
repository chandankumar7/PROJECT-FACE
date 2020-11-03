import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts tts = FlutterTts();

  void setTts() async {
    await tts.setLanguage('en-IN');
    await tts.setVolume(1.0);
    await tts.setSpeechRate(1.0);
  }

  void tellCurrentScreen(String screen) async {
    setTts();
    await tts.speak("You are on " + screen + "Screen");
  }

  void tellPress(String button) async {
    setTts();
    await tts.speak(button);
  }

  void promptInput(String string)async{
    setTts();
    await tts.speak(string);
  }
  
  void inputPlayback(String string)async{
    var processed=string.split("");
    processed.forEach((element) async{
      await tts.speak(element);
    });
  }
}
