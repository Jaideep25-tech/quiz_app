import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/quizanswereview.dart';
import 'package:quiz_app/quizanswered.dart';
import 'package:quiz_app/quizbloc.dart';
import 'package:quiz_app/quizfinished.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizInitial) {
            return Center(
              child: ElevatedButton(
                child: const Text('Start Quiz'),
                onPressed: () {
                  context.read<QuizBloc>().add(FetchQuiz());
                },
              ),
            );
          } else if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            return QuizQuestionView(state: state);
          } else if (state is QuizAnswered) {
            return QuizAnswerView(state: state);
          } else if (state is QuizFinished) {
            return const QuizFinishedView();
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}
