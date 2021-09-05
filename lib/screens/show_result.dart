import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/const/const.dart';
import 'package:quiz_app/database/db_helper.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';
import 'package:quiz_app/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/widgets/count_down.dart';
import 'package:quiz_app/widgets/question_body.dart';

class MyResultPage extends StatefulWidget {
  MyResultPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyResultPageState createState() => _MyResultPageState();
}

class _MyResultPageState extends State<MyResultPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sınav"),
              leading: GestureDetector(
                onTap: () => Navigator.popUntil(
                    context, ModalRoute.withName('/homePage')),
                child: Icon(Icons.arrow_back),
              ),
            ),
            body: Container(
              color: Colors.white10,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  AutoSizeText(
                    "Limit",
                    style: TextStyle(color: Colors.blueAccent),
                    maxLines: 1,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 28,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "Skor ${((10.0 / context.read(userListAnswer).state.length) * context.read(userListAnswer).state.where((answer) => answer.isCorrect).toList().length).toStringAsFixed(1)} / 10.0",
                    style: TextStyle(color: Colors.blueAccent),
                    maxLines: 1,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 28,
                    percent: context
                            .read(userListAnswer)
                            .state
                            .where((e) => e.isCorrect)
                            .toList()
                            .length /
                        context.read(userListAnswer).state.length,
                    backgroundColor: Colors.brown,
                    progressColor: Colors.red,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                // color: Colors.green,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Doğru Cevap")
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Yanlış Cevap")
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                // color: Colors.grey,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Boş Cevap")
                            ],
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: 1.0,
                    padding: const EdgeInsets.all(4),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: context
                        .read(userListAnswer)
                        .state
                        .asMap()
                        .entries
                        .map((question) {
                      return GestureDetector(
                        child: Card(
                          elevation: 2,
                          color: question.value.answered.isEmpty
                              ? Colors.white
                              : question.value.isCorrect
                                  ? Colors.green
                                  : Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'No ${question.key + 1} \n ${question.value.answered}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: question.value.answered.isEmpty
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          var questionNeedView =
                              await getQuestionById(question.value.questionId);
                          context.read(userViewQuestionState).state =
                              questionNeedView;
                          Navigator.pushNamed(context, "/questionDetail");
                        },
                      );
                    }).toList(),
                  ))
                ],
              ),
            )),
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        });
  }

  void showCloseDialog() {}

  Future<Question> getQuestionById(questionId) async {
    var db = await copyDb();
    return QuestionProvider().getQuestionById(db, questionId);
  }
}
