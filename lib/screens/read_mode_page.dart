import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/database/category_provider.dart';
import 'package:quiz_app/database/db_helper.dart';
import 'package:quiz_app/database/question_provider.dart';
import 'package:quiz_app/model/user_answer_model.dart';
import 'package:quiz_app/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/utils/utils.dart';
import 'package:quiz_app/widgets/question_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadModePage extends StatefulWidget {
  const ReadModePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ReadModePageState createState() => _ReadModePageState();
}

class _ReadModePageState extends State<ReadModePage> {
  SharedPreferences prefs;
  int indexPage = 0;
  CarouselController buttonCarouselController = CarouselController();
  List<UserAnswer> userAnswers = new List<UserAnswer>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      indexPage = await prefs.getInt(
              '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}') ??
          0;
      print("save index page" + indexPage.toString());

      Future.delayed(Duration(milliseconds: 500))
          .then((value) => buttonCarouselController.animateToPage(indexPage));
    });
  }

  @override
  Widget build(BuildContext context) {
    var questionModule = context.read(questionCategoryState).state;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              questionModule.name,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            leading: GestureDetector(
              onTap: () => showCloseDialog(questionModule),
              child: Icon(Icons.arrow_back),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: FutureBuilder<List<Question>>(
              future: getQuestionByCategory(questionModule.ID),
              builder: (context, AsyncSnapshot<List<Question>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
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
                                  carouselController: buttonCarouselController,
                                  questions: snapshot.data,
                                  userAnswers: userAnswers,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () => showAnswer(context),
                                        child: Text("Cevabı Göster"))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Center(
                      child: Text("Kategoride Soru Bulunmamaktadır"),
                    );
                } else
                  return Center(
                    child: Text("Kategoride Soru Bulunmamaktadır"),
                  );
              },
            ),
          ),
        ),
        onWillPop: () async {
          showCloseDialog(questionModule);
          return true;
        });
  }

  showCloseDialog(Category questionModule) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text("Kapat"),
              content: Text("Kaldığın yeri kaydetmek İstiyor Musunuz?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //Close Dialog
                      Navigator.pop(context); //Close Screen
                    },
                    child: Text("Hayır")),
                TextButton(
                    onPressed: () {
                      prefs.setInt(
                          '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}',
                          context.read(currentReadPage).state);
                      Navigator.of(context).pop(); //Close Dialog
                      Navigator.pop(context); //Close Screen
                    },
                    child: Text("Evet"))
              ],
            ));
  }

  Future<List<Question>> getQuestionByCategory(int id) async {
    var db = await copyDb();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id);
    return result;
  }
}
