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
    controller = ArmadilloEditingController(
        initialData: [
          Question(
              id: "0",
              label: "Pergunta 1",
              options: ["a", "b", "c"],
              answer: "a")
        ],
        trailPlan: (questions) {
          if (questions.last.id == "4") {
            return null;
          }
          final questionNumber = (questions.length + 1).toString();
          return Question(
              id: questionNumber,
              label: "Pergunta " + questionNumber,
              options: ["a", "b", "c"]);
        }, trailEnded: (questions) {
          print("Chegou no final");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Armadillo(controller: controller));
  }
}
