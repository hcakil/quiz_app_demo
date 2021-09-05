import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/database/category_provider.dart';
import 'package:quiz_app/database/db_helper.dart';
import 'package:quiz_app/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyCategoryPageState createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: GoogleFonts.mcLaren(),
          ),
        ),
        body: FutureBuilder(
          future: getCategories(),
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              //categories is there anymore
              //we add one more category named Exam
              Category category = new Category();
              category.ID = -1;
              category.name = "Sınav";
              category.image = "assets/images/tr.png";
              snapshot.data.add(category);

              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: snapshot.data.map((category) {
                  return GestureDetector(
                    child: Card(
                      elevation: 2,
                      color: category.ID == -1 ? Colors.green : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: AutoSizeText(
                              '${category.name}',
                              style: TextStyle(
                                color: category.ID == -1
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      context.read(questionCategoryState).state = category;
                      if (category.ID != -1) {
                        // is it exam or not
                        context.read(isTestMode).state = false;
                        Navigator.pushNamed(context, "/readMode");
                      } else {
                        // is it exam
                        context.read(isTestMode).state = true;
                        Navigator.pushNamed(context, "/testMode");
                      }
                    },
                  );
                }).toList(),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ));
  }

  Future<List<Category>> getCategories() async {
    var db = await copyDb();
    var result = await CategoryProvider().getCategories(db);
    context.read(categoryListProvider).state = result;
    if (result != null)
      return result;
    else
      return null;
  }
}
