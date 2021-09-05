import 'package:flutter/cupertino.dart';

final db_name = "QuizDb.db";

//bunlar db deki kaşılıkları
final columnMainCategoryID = "ID";
final columnCategoryName = "Name";
final columnCategoryImage = "image";
final tableCategoryName = "Category";

final tableQuestionName = "Question";
final columnQuestionId = "ID";
final columnQuestionText = "QuestionText";
final columnQuestionImage = "QuestionImage";
final columnQuestionAnswerA = "AnswerA";
final columnQuestionAnswerB = "AnswerB";
final columnQuestionAnswerC = "AnswerC";
final columnQuestionAnswerD = "AnswerD";
final columnQuestionCorrectAnswer = "CorrectAnswer";
final columnQuestionIsImageQuestion = "IsImageQuestion";
final columnQuestionCategoryID = "CategoryID";

//Timer
final limitTime = 60;
final limitMinuteTime = 2;
//Color
Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
