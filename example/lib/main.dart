import 'package:flutter/material.dart';
import 'package:armadillo/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  ArmadilloEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = ArmadilloEditingController(initialData: [
      Question(label: "Pergunta 1", options: ["a", "b", "c"], answer: "a")
    ], questionAnswered: questionAnswered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Armadillo(controller: controller));
  }

  questionAnswered(Question question, answer) {
    final questionNumber  =(controller.questions.length+1).toString();
    final newQuestion = Question(label: "Pergunta " + questionNumber, options: ["a", "b", "c"]);
    controller.addQuestion(newQuestion);
  }
}
