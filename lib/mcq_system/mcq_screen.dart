import 'package:flutter/material.dart';
import 'mcq_service.dart';
import 'mcq_model.dart';

class MCQScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  MCQScreen({required this.category, required this.difficulty});

  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  final MCQService _mcqService = MCQService();
  List<MCQ> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _mcqService.fetchMCQs(widget.category, widget.difficulty);
    setState(() {
      _questions = questions;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_questions[_currentQuestionIndex].correctAnswer == selectedAnswer) {
      setState(() {
        _score += 10;
      });
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Show result or leaderboard
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Finished!"),
        content: Text("Your score: $_score"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return Center(child: CircularProgressIndicator());

    MCQ currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz - ${widget.category}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: currentQuestion.options.map((option) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
