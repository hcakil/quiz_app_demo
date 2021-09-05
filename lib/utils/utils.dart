import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';
import 'package:quiz_app/state/state_manager.dart';

void setUserAnswer(BuildContext context, MapEntry<int, Question> e, value) {
  context.read(userListAnswer).state[e.key] =
      context.read(userAnswerSelected).state = new UserAnswer(
          questionId: e.value.questionId,
          answered: value,
          isCorrect: value.toString().isNotEmpty
              ? value.toString().toLowerCase() ==
                  e.value.correctAnswer.toLowerCase()
              : false);
}

void showAnswer(BuildContext context) {
  context.read(isEnabledShowAnswer).state = true;
}
