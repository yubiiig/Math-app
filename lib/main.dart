import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MathApp());
}

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '수학 퀴즈 클래스',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _controller = TextEditingController();
  int _num1 = 0;
  int _num2 = 0;
  int _score = 0;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    final random = Random();
    setState(() {
      _num1 = random.nextInt(8) + 2;
      _num2 = random.nextInt(8) + 2;
      _controller.clear();
    });
  }

  void _checkAnswer() {
    final userAns = int.tryParse(_controller.text);
    if (userAns == null) return;

    if (userAns == _num1 * _num2) {
      setState(() {
        _score += 10;
        _message = '정답입니다! 🎉';
      });
    } else {
      setState(() {
        _message = '오답입니다! 정답: ${_num1 * _num2}';
      });
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _message = '');
        _generateProblem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📐 수학 퀴즈 클래스'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_num1 × $_num2 = ?',
              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '정답 입력',
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('정답 제출', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _message.contains('정답입니다') ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text('현재 점수: $_score점', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}