import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Enum to represent the current state of the TTS engine
enum TtsState { playing, stopped }

class TtsService {
  late final FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;

  // Callback to notify the UI of state changes
  VoidCallback? onStateChanged;

  TtsService() {
    _flutterTts = FlutterTts();

    // Set a slower speech rate for better accessibility for all users
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setPitch(1.0);

    // Set up listeners to update the state
    _flutterTts.setStartHandler(() {
      _updateState(TtsState.playing);
    });

    _flutterTts.setCompletionHandler(() {
      _updateState(TtsState.stopped);
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS Error: $msg");
      _updateState(TtsState.stopped);
    });
  }

  // Getter for the current TTS state
  TtsState get ttsState => _ttsState;

  // Helper to update state and notify listeners
  void _updateState(TtsState newState) {
    _ttsState = newState;
    onStateChanged?.call();
  }

  /// Sets the language for speech synthesis.
  /// Examples: 'en-US', 'hi-IN', 'te-IN'
  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  /// Speaks the provided text.
  /// If text is already playing, it will be stopped first.
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      // Stop any currently playing speech before starting new speech
      await stop();
      await _flutterTts.speak(text);
    }
  }

  /// Stops the current speech.
  Future<void> stop() async {
    if (_ttsState == TtsState.playing) {
      await _flutterTts.stop();
    }
  }

  /// Must be called from a dispose() method to release resources.
  void dispose() {
    _flutterTts.stop();
    onStateChanged = null;
  }
}
