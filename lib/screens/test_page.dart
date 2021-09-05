import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/const/const.dart';
import 'package:quiz_app/database/db_helper.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';
import 'package:quiz_app/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/widgets/count_down.dart';
import 'package:quiz_app/widgets/question_body.dart';

class MyTestModePage extends StatefulWidget {
  MyTestModePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyTestModePageState createState() => _MyTestModePageState();
}

class _MyTestModePageState extends State<MyTestModePage>
    with TickerProviderStateMixin {
  CarouselController carouselController = new CarouselController();
  List<UserAnswer> userAnswers = new List<UserAnswer>();
  AnimationController _controller;
  AnimationController _controllerMinute;

  @override
  void dispose() {
    // TODO: implement dispose
    if ((_controller.isAnimating && _controllerMinute.isAnimating) ||
        (_controller.isCompleted && _controllerMinute.isCompleted)) {
      _controller.dispose();
      _controllerMinute.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: limitTime));

    _controllerMinute = AnimationController(
        vsync: this, duration: Duration(minutes: limitMinuteTime));

    _controllerMinute.addListener(() {
      if (_controllerMinute.isCompleted) {
        print("dakika bitti diğerini ben bitirdim");
        _controller.stop();
        Navigator.of(context).pop;
        Navigator.of(context).pushNamed("/showResult");
      } else if (_controllerMinute.isAnimating && _controller.isCompleted) {
        print("DAKİKA devam ediyor --Ama SANİYE bitti");
        _controller.repeat(period: Duration(seconds: limitTime));
      }
    });

    _controller.addListener(() {
      if (_controllerMinute.isCompleted) {
        print("İkiside bitti");
        Navigator.of(context).pop;
        Navigator.of(context).pushNamed("/showResult");
      }
    });
    _controller.forward();
    _controllerMinute.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sınav"),
            leading: GestureDetector(
              onTap: () => showCloseExamDialog(),
              child: Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                              title: Text("Sınavım"),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.0,
                                  padding: const EdgeInsets.all(4),
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  children: context
                                      .read(userListAnswer)
                                      .state
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    return GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: AutoSizeText(
                                          'No ${e.key + 1}:${e.value.answered == null || e.value.answered.isEmpty ? ' ' : e.value.answered}',
                                          style: TextStyle(
                                              fontWeight: (e.value.answered !=
                                                          null &&
                                                      !e.value.answered.isEmpty)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          maxLines: 1,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        carouselController.animateToPage(e.key);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); //Close Dialog
                                    },
                                    child: Text("Kapat")),
                              ],
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.note),
                            Text("Cevaplar"),
                          ],
                        )),
                    Row(
                      children: [
                        /**/ CountDownMinute(
                          animation: StepTween(begin: limitMinuteTime, end: 0)
                              .animate(_controllerMinute),
                        ),
                        countDownSeconds(),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          showFinishDialog();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.done),
                            Text("Bitir"),
                          ],
                        ))
                  ],
                ),
                FutureBuilder<List<Question>>(
                    future: getQuestion(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      else if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 10, left: 4, right: 4),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuestionBody(
                                      context: context,
                                      carouselController: carouselController,
                                      questions: snapshot.data,
                                      userAnswers: userAnswers,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else
                        return Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          ),
        ),
        onWillPop: () async {
          showCloseExamDialog();
          return true;
        });
  }

  void showCloseExamDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text("Bitir"),
              content: Text("Sınavdan Çıkmak İstiyor Musunuz?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //Close Dialog
                    },
                    child: Text("Hayır")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //Close Dialog
                      Navigator.pop(context); //Close Screen
                    },
                    child: Text("Evet"))
              ],
            ));
  }

  Future<List<Question>> getQuestion() async {
    var db = await copyDb();
    var result = await QuestionProvider().getQuestions(db);
    userAnswers.clear();
    result.forEach((element) {
      userAnswers.add(new UserAnswer(
          questionId: element.questionId, answered: "", isCorrect: false));
    });
    context.read(userListAnswer).state = userAnswers;
    return result;
  }

  void showFinishDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text("Bitir"),
              content: Text("Sınavı Gerçekten Bitirmek İstiyor Musunuz?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //Close Dialog
                    },
                    child: Text("Hayır")),
                TextButton(
                    onPressed: () {
                      context.read(userListAnswer).state = userAnswers;
                      Navigator.of(context).pop(); //Close Dialog
                      Navigator.pop(context); //Close Dialog
                      Navigator.of(context).pushReplacementNamed("/showResult");
                    },
                    child: Text("Evet"))
              ],
            ));
  }

  CountDown countDownSeconds() {
    return CountDown(
        animation: StepTween(begin: limitTime, end: 0).animate(_controller));
  }
}
