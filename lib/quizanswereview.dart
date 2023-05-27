import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/quizanswered.dart';
import 'package:quiz_app/quizbloc.dart';

class QuizAnswerView extends StatelessWidget {
  final QuizAnswered state;

  const QuizAnswerView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          state.isCorrect ? 'Correct!' : 'Incorrect!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Your answer: ${state.selectedOption}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (!state.isCorrect)
          Text(
            'Correct answer: ${state.correctAnswer}',
            style: const TextStyle(fontSize: 18),
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text('Next Question'),
          onPressed: () {
            context.read<QuizBloc>().add(NextQuestion());
          },
        ),
      ],
    );
  }
}
