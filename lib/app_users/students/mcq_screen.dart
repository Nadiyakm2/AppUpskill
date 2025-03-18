import 'package:flutter/material.dart';
import 'package:upskill_app/app_users/students/mcq_service.dart';
import '../students/mcq_model.dart';
import 'package:upskill_app/utils/app_routes.dart';

class MCQScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const MCQScreen({Key? key, required this.category, required this.difficulty}) : super(key: key);

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null) {
      setState(() {
        _loadQuestions();
      });
    }
  }

  Future<void> _loadQuestions() async {
    final questions = await _mcqService.fetchMCQs(widget.category, widget.difficulty);
    setState(() {
      _questions = questions;
    });
  }

  void _showResult() {
    Navigator.pushNamed(context, AppRoutes.leaderboardScreen, arguments: {'score': _score});
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return Center(child: CircularProgressIndicator());

    MCQ currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz - ${widget.category}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(currentQuestion.question, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Column(
              children: currentQuestion.options.map((option) {
                return ElevatedButton(
                  onPressed: () => setState(() {
                    if (currentQuestion.correctAnswer == option) {
                      _score += 10;
                    }
                    if (_currentQuestionIndex < _questions.length - 1) {
                      _currentQuestionIndex++;
                    } else {
                      _showResult();
                    }
                  }),
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
