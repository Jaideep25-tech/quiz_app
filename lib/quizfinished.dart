import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/quizbloc.dart';

class QuizFinishedView extends StatelessWidget {
  const QuizFinishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Finished!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Restart Quiz'),
            onPressed: () {
              // context.read<QuizBloc>().add(QuizAnswered());
              context.read<QuizBloc>().add(FetchQuiz());
            },
          ),
        ],
      ),
    );
  }
}
