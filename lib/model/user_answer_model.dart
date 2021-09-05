class UserAnswer {
  int questionId;
  String answered;
  bool isCorrect;

  UserAnswer({this.questionId, this.answered, this.isCorrect});
  Map ToJson() => {
        "questionId": questionId,
        "answered": answered,
        "isCorrect": isCorrect,
      };
}
