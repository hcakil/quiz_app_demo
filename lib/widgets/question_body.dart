import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';
import 'package:quiz_app/state/state_manager.dart';
import 'package:quiz_app/utils/utils.dart';

class QuestionBody extends StatelessWidget {
  QuestionBody({
    Key key,
    this.context,
    this.userAnswers,
    this.carouselController,
    this.questions,
  }) : super(key: key);

  BuildContext context;
  List<UserAnswer> userAnswers;
  CarouselController carouselController;
  List<Question> questions;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        carouselController: carouselController,
        items: questions
            .asMap()
            .entries
            .map((e) => Builder(builder: (context) {
                  return Consumer(builder: (context, watch, _) {
                    var userAnswerState = watch(userAnswerSelected).state;
                    var isShowAnswer = watch(isEnabledShowAnswer).state;
                    return Column(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            //if reaad mode is open show only a number starts from 0
                            //else show question id
                            AutoSizeText(context.read(isTestMode).state
                                ? "No ${e.key + 1}:${e.value.questionText}"
                                : "No ${e.value.questionId}:${e.value.questionText}"), //Question
                            Visibility(
                                visible: (e.value.isImageQuestion == null ||
                                        e.value.isImageQuestion == 0
                                    ? false
                                    : true),
                                child: Container(
                                  height: MediaQuery.of(context).size.height /
                                      15 *
                                      3,
                                  child: e.value.isImageQuestion == 0
                                      ? Container()
                                      : Image(
                                          image: AssetImage(
                                              'assets/images/tr.png')),
                                )), //Image

                            Expanded(
                                child: ListTile(
                              title: AutoSizeText(
                                "${e.value.answerA}",
                                style: TextStyle(
                                    color: isShowAnswer
                                        ? e.value.correctAnswer == "A"
                                            ? Colors.red
                                            : Colors.grey
                                        : Colors.black),
                              ),
                              leading: Radio(
                                  value: "A",
                                  groupValue: getGroupValue(
                                      isShowAnswer, e, userAnswerState),
                                  onChanged: (value) {
                                    print(value + "  --<value");
                                    print(context.toString() + "  --<context");
                                    print(e.toString() + "  --<value");
                                    setUserAnswer(context, e, value);
                                  }),
                            )) //Answer A
                            ,
                            Expanded(
                                child: ListTile(
                              title: AutoSizeText(
                                "${e.value.answerB}",
                                style: TextStyle(
                                    color: isShowAnswer
                                        ? e.value.correctAnswer == "B"
                                            ? Colors.red
                                            : Colors.grey
                                        : Colors.black),
                              ),
                              leading: Radio(
                                value: "B",
                                groupValue: getGroupValue(
                                    isShowAnswer, e, userAnswerState),
                                onChanged: (value) =>
                                    setUserAnswer(context, e, value),
                              ),
                            )) //Answer B
                            ,
                            Expanded(
                                child: ListTile(
                              title: AutoSizeText(
                                "${e.value.answerC}",
                                style: TextStyle(
                                    color: isShowAnswer
                                        ? e.value.correctAnswer == "C"
                                            ? Colors.red
                                            : Colors.grey
                                        : Colors.black),
                              ),
                              leading: Radio(
                                value: "C",
                                groupValue: getGroupValue(
                                    isShowAnswer, e, userAnswerState),
                                onChanged: (value1) =>
                                    setUserAnswer(context, e, value1),
                              ),
                            )) //Answer C
                            ,
                            Expanded(
                                child: ListTile(
                              title: AutoSizeText(
                                "${e.value.answerD}",
                                style: TextStyle(
                                    color: isShowAnswer
                                        ? e.value.correctAnswer == "D"
                                            ? Colors.red
                                            : Colors.grey
                                        : Colors.black),
                              ),
                              leading: Radio(
                                value: "D",
                                groupValue: getGroupValue(
                                    isShowAnswer, e, userAnswerState),
                                onChanged: (value) =>
                                    setUserAnswer(context, e, value),
                              ),
                            )) //Answer D
                          ],
                        ))
                      ],
                    );
                  });
                }))
            .toList(),
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            initialPage: 0,
            height: MediaQuery.of(context).size.height / 5 * 3,
            onPageChanged: (page, _) {
              context.read(currentReadPage).state = page;
              context.read(isEnabledShowAnswer).state = false;
            }));
  }

  getGroupValue(bool isShowAnswer, MapEntry<int, Question> e,
      UserAnswer userAnswerState) {
    return isShowAnswer
        ? e.value.correctAnswer
        : (context.read(isTestMode).state
            ? context.read(userListAnswer).state[e.key].answered
            : "");
  }
}
