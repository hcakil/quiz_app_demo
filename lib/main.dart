import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/question_detail.dart';
import 'package:quiz_app/screens/read_mode_page.dart';
import 'package:quiz_app/screens/show_result.dart';
import 'package:quiz_app/screens/test_page.dart';

import 'const/const.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "/homePage": (context) => MyCategoryPage(
              title: "My Quiz",
            ),
        "/readMode": (context) => ReadModePage(),
        "/testMode": (context) => MyTestModePage(),
        "/showResult": (context) => MyResultPage(),
        "/questionDetail": (context) => MyQuestionDetailPage(),
      },
      theme: ThemeData(
        primarySwatch: colorCustom,
        accentColor: colorCustom[500],
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(title: 'Pratix Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/homePage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          Center(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
