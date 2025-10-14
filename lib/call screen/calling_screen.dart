import 'dart:async';
import 'package:ai_math_solver/utils/colors_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils/asset_paths.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final FlutterTts tts = FlutterTts();
  late stt.SpeechToText _speech;
  Gemini? gemini;

  bool _isListening = false;
  bool _isMuted = false;
  bool _isSpeaking = false;
  bool _endCall = false;

  int _callSeconds = 0; // ✅ Timer seconds
  Timer? _timer;

  String _status = "Connecting...";
  String _botResponse = "";

  @override
  void initState() {
    super.initState();

    Gemini.init(apiKey: "AIzaSyB7NToCpz_ckbWPpQ01ApEEQGHRy-EyMR0");
    gemini = Gemini.instance;
    _speech = stt.SpeechToText();

    // Start call timer
    _startCallTimer();

    // Start conversation automatically
    Future.delayed(const Duration(seconds: 2), _autoConversationLoop);
  }

  // ✅ Call timer
  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_endCall) {
        setState(() => _callSeconds++);
      }
    });
  }

  String get _formattedTime {
    final minutes = (_callSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_callSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // 🔁 Main loop for AI conversation
  Future<void> _autoConversationLoop() async {
    while (!_endCall) {
      if (_isListening) break; // Wait until user speaks
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // 🎙 Start speech recognition
  Future<void> _startListening() async {
    if (_endCall) return;

    bool available = await _speech.initialize();
    if (!available) {
      setState(() => _status = "Speech not available");
      return;
    }

    setState(() {
      _isListening = true;
      _status = "Listening...";
    });

    _speech.listen(
      listenMode: stt.ListenMode.dictation,
      onResult: (result) async {
        if (result.finalResult && !_endCall) {
          final userText = result.recognizedWords.characters.string;
          if (userText.isNotEmpty) {
            setState(() {
              _isListening = false;
              _status = "Thinking...";
            });
            await _askGemini(userText);
          }
        }
      },
    );
  }

  // 🧠 Ask Gemini
  Future<void> _askGemini(String question) async {
    try {
      final response = await gemini?.text("Answer concisely: $question");

      final answer =
          response?.output ??
              response?.content?.parts
                  ?.map((p) => p.toString().characters ?? "")
                  .join(" ")
                  .trim() ??
              "";

      final safeAnswer = (answer.isNotEmpty) ? answer : "I don't know.";

      setState(() {
        _botResponse = "";
        _status = "Speaking...";
        _isSpeaking = true;
      });

      if (!_isMuted) {
        await _speak(safeAnswer);
      }

      setState(() {
        _isSpeaking = false;
        _status = _isListening ? "Listening..." : "Idle";
      });
    } catch (e) {
      setState(() => _status = "Error: $e");
    }
  }

  // 🔊 Text-to-Speech
  Future<void> _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.6);
    await tts.setVolume(1.0);
    await tts.speak(text);
  }

  // ☎️ End call
  Future<void> _endCallNow() async {
    setState(() {
      _endCall = true;
      _status = "Call ended";
    });
    _timer?.cancel();
    if (_speech.isListening) await _speech.stop();
    await tts.stop();

    // ✅ Navigate to Dashboard after call ends
    // Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Image.asset(
            AssetPaths().calline_img_background,
            height: size.height,
            width: size.width,
            fit: BoxFit.fill,
          ),

          // Caller info
          Positioned(
            left: 0,
            right: 0,
            top: 150,
            child: Column(
              children: [
                Text(
                  _formattedTime,
                  style: TextStyle(
                    color: ColorsPaths().white_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 70),
                Image.asset(AssetPaths().calling_person_img, height: 200),
                const SizedBox(height: 15),
                Text(
                  'Jessica Alba',
                  style: TextStyle(
                    color: ColorsPaths().white_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _status,
                  style: TextStyle(
                    color: ColorsPaths().white_color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_botResponse.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Jessica: $_botResponse",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Buttons
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() => _isMuted = !_isMuted);

                          if (_isListening) {
                            // Stop listening and trigger AI response
                            setState(() => _isListening = false);
                            await _askGemini(
                                "User is silent, give concise response");
                          } else {
                            // Start listening
                            await _startListening();
                          }
                        },
                        child: Image.asset(
                          AssetPaths().mute_button,
                          height: 50,
                          color: _isMuted ? Colors.redAccent : null,
                        ),
                      ),
                      Image.asset(AssetPaths().loud_button, height: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _endCallNow,
                  child: Image.asset(AssetPaths().call_button, height: 50),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
