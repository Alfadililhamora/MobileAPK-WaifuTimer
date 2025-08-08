import 'dart:async';
import 'package:belajar1/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const WaifuTimerApp()));
}

class WaifuTimerApp extends StatelessWidget {
  const WaifuTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waifu Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'CherryBombOne',
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: const SplashScreen(),
    );
  }
}

class KawaiiTimerScreen extends StatefulWidget {
  const KawaiiTimerScreen({super.key});

  @override
  State<KawaiiTimerScreen> createState() => _KawaiiTimerScreenState();
}

class _KawaiiTimerScreenState extends State<KawaiiTimerScreen> {
  final TextEditingController _minuteController = TextEditingController(
    text: '0',
  );
  final TextEditingController _secondController = TextEditingController(
    text: '0',
  );

  late Timer _timer;
  bool _isRunning = false;
  int _secondsRemaining = 0;

  final List<String> _motivationalMessages = [
    "がんばって！ (Ganbatte!)",
    "まだまだ！(Madamada!)",
    "あと少し！(Ato sukoshi!)",
    "ファイト！(Faito!)",
    "いい感じ！(Ii kanji!)",
    "やればできる！(Yareba dekiru!)",
  ];
  int _currentMessageIndex = 0;

  void _startTimer() {
    final int minutes = int.tryParse(_minuteController.text) ?? 0;
    final int seconds = int.tryParse(_secondController.text) ?? 0;
    final totalSeconds = minutes * 60 + seconds;

    if (totalSeconds <= 0) return;

    setState(() {
      _secondsRemaining = totalSeconds;
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        setState(() => _isRunning = false);
      } else {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining % 10 == 0) {
            _currentMessageIndex =
                (_currentMessageIndex + 1) % _motivationalMessages.length;
          }
        });
      }
    });
  }

  void _resetTimer() {
    if (_isRunning) _timer.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 0; // Reset to 00:00
      _minuteController.text = '0';
      _secondController.text = '0';
      _currentMessageIndex = 0;
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = twoDigits(_secondsRemaining ~/ 60);
    final seconds = twoDigits(_secondsRemaining % 60);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/waifu.jpg', fit: BoxFit.cover),
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$minutes:$seconds",
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _motivationalMessages[_currentMessageIndex],
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeInput(_minuteController, 'Menit'),
                    const SizedBox(width: 20),
                    _buildTimeInput(_secondController, 'Detik'),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text('Mulai'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(TextEditingController controller, String label) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        enabled: !_isRunning,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }
}
