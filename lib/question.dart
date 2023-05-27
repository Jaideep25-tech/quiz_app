class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question(
      {required this.question,
      required this.correctAnswer,
      required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    final String question = json['question'];
    final String correctAnswer = json['correct_answer'];
    final List<dynamic> incorrectAnswers = json['incorrect_answers'];
    final List<String> options = [
      correctAnswer,
      ...incorrectAnswers.map((answer) => answer.toString())
    ];
    return Question(
        question: question, correctAnswer: correctAnswer, options: options);
  }
}
