import 'package:quiz_app/question.dart';
import 'package:quiz_app/quizbloc.dart';

class Quiz {
  final List<Question> questions;

  Quiz({required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final List<dynamic> results = json['results'];
    final questions =
        results.map((result) => Question.fromJson(result)).toList();
    return Quiz(questions: questions);
  }
}

class QuizAnswered extends QuizLoaded {
  final bool isCorrect;
  String? correctAnswer;

  QuizAnswered({
    required this.isCorrect,
    required Quiz quiz,
    required int currentQuestion,
    required String? selectedOption,
    required String correctAnswer,
  }) : super(
          quiz: quiz,
          currentQuestion: currentQuestion,
          selectedOption: selectedOption,
        );

  QuizAnswered copyWith({
    int? currentQuestion,
    String? selectedOption,
  }) {
    return QuizAnswered(
      isCorrect: isCorrect,
      quiz: quiz,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedOption: selectedOption ?? this.selectedOption,
      correctAnswer: correctAnswer.toString(),
    );
  }
}
