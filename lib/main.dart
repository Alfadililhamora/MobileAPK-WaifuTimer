import 'dart:async';
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
      debugShowCheckedModeBanner: false,
      title: 'Waifu Timer',
      theme: ThemeData(
        fontFamily: 'CherryBombOne',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFF6B8B),
          secondary: const Color(0xFFFF8E9E),
          surface: const Color(0xFFFFF0F5),
        ),
      ),
      home: const KawaiiTimerScreen(),
    );
  }
}

class KawaiiTimerScreen extends StatefulWidget {
  const KawaiiTimerScreen({super.key});

  @override
  State<KawaiiTimerScreen> createState() => _KawaiiTimerScreenState();
}

class _KawaiiTimerScreenState extends State<KawaiiTimerScreen> {
  int _secondsRemaining = 300;
  bool _isRunning = false;
  late Timer _timer;
  int _currentMessageIndex = 0;

  final List<String> _kawaiiMessages = [
    "がんばってね! (You can do it!)",
    "かわいい! (So cute!)",
    "すごい! (Amazing!)",
    "えらい! (Good job!)",
    "もう少し! (Almost there!)",
  ];

  @override
  void initState() {
    super.initState();
    _currentMessageIndex = 0;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
            if (_secondsRemaining % 15 == 0) {
              _currentMessageIndex =
                  (_currentMessageIndex + 1) % _kawaiiMessages.length;
            }
          });
        } else {
          _timer.cancel();
          setState(() => _isRunning = false);
          _showCompletionDialog();
        }
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() => _isRunning = false);
    }
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 300;
      _currentMessageIndex = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF0F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("お疲れ様!", style: TextStyle(color: Color(0xFFFF6B8B))),
        content: const Text(
          "Time's up! よくできました!",
          style: TextStyle(color: Color(0xFFFF8E9E)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: const Text("OK", style: TextStyle(color: Color(0xFFFF6B8B))),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B8B),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'My Istri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'CherryBombOne',
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              'Istri Alfadil',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'CherryBombOne',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B8B).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/waifu.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.heart_broken,
                      size: 100,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B8B),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _kawaiiMessages[_currentMessageIndex],
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFF8E9E),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    backgroundColor: const Color(0xFFFF6B8B),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _resetTimer,
                    backgroundColor: const Color(0xFFFF8E9E),
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
