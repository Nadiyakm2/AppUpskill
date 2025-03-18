import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define the structure of each question
class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class MediumLevelScreen extends StatefulWidget {
  const MediumLevelScreen({super.key});

  @override
  _MediumLevelScreenState createState() => _MediumLevelScreenState();
}

class _MediumLevelScreenState extends State<MediumLevelScreen> {
  // Define separate question lists for Theory, Coding, and Aptitude
  final List<Question> theoryQuestions = [
    Question(
      questionText: 'Which of the following is NOT a valid application of a stack?',
      options: ['Undo functionality in text editors', 'Sorting elements in ascending order', 'Balancing parentheses in expressions', 'Expression evaluation (postfix, prefix)'],
      correctAnswerIndex: 1, // Correct answer is 'Sorting elements in ascending order'
    ),
    Question(
      questionText: 'What is the primary disadvantage of a linked list over an array?',
      options: ['Faster element access', 'Can store only homogeneous data', 'Requires more memory for each element', 'Supports random access'],
      correctAnswerIndex: 2, // Correct answer is 'Requires more memory for each element'
    ),
  ];

  final List<Question> codingQuestions = [
    Question(
      questionText: 'Which of the following Java methods is used to add an element to the end of an ArrayList?',
      options: ['push()', 'insert()', 'append()', 'add()'],
      correctAnswerIndex: 3, // Correct answer is 'add()'
    ),
    Question(
      questionText: 'In a doubly linked list, what would happen if you try to delete the last element without updating the "previous" pointer of the second last node?',
      options: ['It will cause a memory leak', 'The second last node will be removed from the list', 'The list will still work correctly', 'It will result in a runtime error'],
      correctAnswerIndex: 0, // Correct answer is 'It will cause a memory leak'
    ),
  ];

  final List<Question> aptitudeQuestions = [
    Question(
      questionText: 'Given an unsorted array, what would be the best data structure to store the unique elements efficiently?',
      options: ['Array', 'Stack', 'Hash Set', 'Linked List'],
      correctAnswerIndex: 2, // Correct answer is 'Hash Set'
    ),
    Question(
      questionText: 'If the maximum depth of a binary tree is 5, what is the maximum number of nodes that the tree can have?',
      options: ['5', '15', '31', '63'],
      correctAnswerIndex: 2, // Correct answer is '31'
    ),
  ];

  // List to track selected answers for each question
  List<int?> selectedAnswersTheory = List.filled(2, null); // For Theory (2 questions)
  List<int?> selectedAnswersCoding = List.filled(2, null); // For Coding (2 questions)
  List<int?> selectedAnswersAptitude = List.filled(2, null); // For Aptitude (2 questions)

  // Flags to check if answers have been submitted
  bool submittedTheory = false;
  bool submittedCoding = false;
  bool submittedAptitude = false;

  // Scores for each section
  int scoreTheory = 0;
  int scoreCoding = 0;
  int scoreAptitude = 0;

  // Fetch the logged-in user's email
  String get userEmail {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.email ?? "guest@example.com"; // Default email if user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medium Level Questions'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExpandableContainer(
              title: 'Theory',
              selectedAnswers: selectedAnswersTheory,
              questions: theoryQuestions,
              onSubmit: () {
                setState(() {
                  submittedTheory = true;
                  scoreTheory = _calculateScore(theoryQuestions, selectedAnswersTheory);
                  _submitDataToSupabase("Data Structures", "Medium", "Theory", scoreTheory);
                });
              },
              submitted: submittedTheory,
              score: scoreTheory,
            ),
            ExpandableContainer(
              title: 'Coding',
              selectedAnswers: selectedAnswersCoding,
              questions: codingQuestions,
              onSubmit: () {
                setState(() {
                  submittedCoding = true;
                  scoreCoding = _calculateScore(codingQuestions, selectedAnswersCoding);
                  _submitDataToSupabase("Data Structures", "Medium", "Coding", scoreCoding);
                });
              },
              submitted: submittedCoding,
              score: scoreCoding,
            ),
            ExpandableContainer(
              title: 'Aptitude',
              selectedAnswers: selectedAnswersAptitude,
              questions: aptitudeQuestions,
              onSubmit: () {
                setState(() {
                  submittedAptitude = true;
                  scoreAptitude = _calculateScore(aptitudeQuestions, selectedAnswersAptitude);
                  _submitDataToSupabase("Data Structures", "Medium", "Aptitude", scoreAptitude);
                });
              },
              submitted: submittedAptitude,
              score: scoreAptitude,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Calculate score for a given section
  int _calculateScore(List<Question> questions, List<int?> selectedAnswers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        score++;
      }
    }
    return score;
  }

  // Submit data to Supabase
  Future<void> _submitDataToSupabase(String subjectName, String level, String category, int score) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client.from('user_scores').insert([
        {
          'email': user.email,
          'subject_name': subjectName,
          'level': level,
          'category': category,
          'score': score,
        }
      ]);
    } else {
      print("User not logged in");
    }
  }
}

class ExpandableContainer extends StatefulWidget {
  final String title;
  final List<int?> selectedAnswers;
  final List<Question> questions;
  final VoidCallback onSubmit;
  final bool submitted;
  final int score;

  const ExpandableContainer({
    required this.title,
    required this.selectedAnswers,
    required this.questions,
    required this.onSubmit,
    required this.submitted,
    required this.score,
  });

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      onExpansionChanged: (bool expanding) {
        setState(() {
          _isExpanded = expanding;
        });
      },
      children: [
        if (_isExpanded) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length, // Use the length of the questions list
            itemBuilder: (context, index) {
              return _buildQuestion(index);
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: widget.onSubmit,
            child: Text('Submit'),
          ),
          SizedBox(height: 10),
          if (widget.submitted)
            Text(
              'Your score: ${widget.score}/${widget.questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
        ],
      ],
    );
  }

  // Build the question with options
  Widget _buildQuestion(int index) {
    Question question = widget.questions[index]; // Get the question from the list
    return ListTile(
      title: Text(
        '${index + 1}. ${question.questionText}',
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOption(question.options[0], index, 0), // Option A
          _buildOption(question.options[1], index, 1), // Option B
          _buildOption(question.options[2], index, 2), // Option C
          _buildOption(question.options[3], index, 3), // Option D
          if (widget.submitted)
            _buildAnswerFeedback(index, question.correctAnswerIndex)
        ],
      ),
    );
  }

  // Build each option with a radio button
  Widget _buildOption(String option, int questionIndex, int optionIndex) {
    return ListTile(
      title: Text(
        option,
        style: TextStyle(color: Colors.black),
      ),
      leading: Radio<int>(
        value: optionIndex, // The value of the option (0, 1, 2, or 3)
        groupValue: widget.selectedAnswers[questionIndex], // The selected answer for this question
        onChanged: widget.submitted
            ? null
            : (int? value) {
          setState(() {
            // Update the selected answer for the current question
            widget.selectedAnswers[questionIndex] = value;
          });
        },
      ),
    );
  }

  // Display feedback for the answer after submit
  Widget _buildAnswerFeedback(int index, int correctAnswerIndex) {
    if (widget.selectedAnswers[index] == correctAnswerIndex) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Correct Answer',
          style: TextStyle(color: Colors.green),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Incorrect Answer',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
