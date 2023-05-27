import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/quizanswered.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial());

  @override
  Stream<QuizState> mapEventToState(QuizEvent event) async* {
    if (event is FetchQuiz) {
      yield QuizLoading();
      try {
        final quiz = await _fetchQuizFromApi();
        yield QuizLoaded(quiz: quiz);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (event is SubmitAnswer) {
      final currentState = state;
      if (currentState is QuizLoaded) {
        final isCorrect = currentState
                .quiz.questions[currentState.currentQuestion].correctAnswer ==
            event.selectedOption;
        yield QuizAnswered(
          isCorrect: isCorrect,
          selectedOption: event.selectedOption,
          correctAnswer: currentState
              .quiz.questions[currentState.currentQuestion].correctAnswer,
          currentQuestion: currentState.currentQuestion,
          quiz: currentState.quiz,
        );
      }
    } else if (event is NextQuestion) {
      final currentState = state;
      if (currentState is QuizAnswered) {
        if (currentState.currentQuestion + 1 <
            currentState.quiz.questions.length) {
          yield currentState.copyWith(
            currentQuestion: currentState.currentQuestion + 1,
            selectedOption: null,
          );
        } else {
          yield QuizFinished();
        }
      }
    }
  }

  Future<Quiz> _fetchQuizFromApi() async {
    final response =
        await http.get(Uri.parse('https://opentdb.com/api.php?amount=10'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return Quiz.fromJson(decodedData);
    } else {
      throw Exception('Failed to fetch quiz');
    }
  }
}

abstract class QuizEvent {}

class FetchQuiz extends QuizEvent {}

class SubmitAnswer extends QuizEvent {
  final String selectedOption;

  SubmitAnswer({required this.selectedOption});
}

class NextQuestion extends QuizEvent {}

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Quiz quiz;
  final int currentQuestion;
  final String? selectedOption;

  QuizLoaded(
      {required this.quiz, this.currentQuestion = 0, this.selectedOption});
}

class QuizFinished extends QuizState {}

class QuizQuestionView extends StatelessWidget {
  final QuizLoaded state;

  const QuizQuestionView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final question = state.quiz.questions[state.currentQuestion];
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Question ${state.currentQuestion + 1}/${state.quiz.questions.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          question.question,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        for (var option in question.options)
          ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: state.selectedOption,
              onChanged: (value) {
                context
                    .read<QuizBloc>()
                    .add(SubmitAnswer(selectedOption: value!));
              },
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: state.selectedOption == null
              ? null
              : () {
                  context.read<QuizBloc>().add(NextQuestion());
                },
          child: const Text('Next Question'),
        ),
      ],
    );
  }
}
