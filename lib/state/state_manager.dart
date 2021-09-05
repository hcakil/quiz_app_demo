import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/database/category_provider.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';

final categoryListProvider = StateNotifierProvider((ref) => CategoryList([]));
final questionCategoryState = StateProvider((ref) => new Category());
final isTestMode = StateProvider((ref) => false);
final currentReadPage = StateProvider((ref) => 0);
final userAnswerSelected = StateProvider((ref) => new UserAnswer());
final isEnabledShowAnswer = StateProvider((ref) => false);
final userListAnswer = StateProvider((ref) => List<UserAnswer>());
final userViewQuestionState = StateProvider((ref) => new Question());
