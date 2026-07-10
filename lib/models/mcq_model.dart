class MCQQuestion {
  final String questionId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String category;

  MCQQuestion({
    required this.questionId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.category = 'general',
  });

  factory MCQQuestion.fromMap(Map<dynamic, dynamic> map) {
    return MCQQuestion(
      questionId: map['questionId'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'],
      category: map['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
    };
  }
}

class MCQTest {
  final String doctorId;
  final Map<String, int> answers; // questionId -> selectedIndex
  final int totalQuestions;
  final int correctAnswers;
  final double percentage;
  final bool isPassed;
  final DateTime submittedAt;

  MCQTest({
    required this.doctorId,
    required this.answers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
    required this.isPassed,
    required this.submittedAt,
  });

  factory MCQTest.fromMap(Map<dynamic, dynamic> map) {
    return MCQTest(
      doctorId: map['doctorId'] ?? '',
      answers: Map<String, int>.from(map['answers'] ?? {}),
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      percentage: (map['percentage'] ?? 0).toDouble(),
      isPassed: map['isPassed'] ?? false,
      submittedAt: DateTime.tryParse(map['submittedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'answers': answers,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'percentage': percentage,
      'isPassed': isPassed,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}
