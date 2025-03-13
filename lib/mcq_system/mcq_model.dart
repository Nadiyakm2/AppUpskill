class MCQ {
  final int id;
  final String category;
  final String difficulty;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String videoLink;

  MCQ({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.videoLink,
  });

  factory MCQ.fromMap(Map<String, dynamic> map) {
    return MCQ(
      id: map['id'],
      category: map['category'],
      difficulty: map['difficulty'],
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswer: map['correct_answer'],
      videoLink: map['video_link'],
    );
  }
}
