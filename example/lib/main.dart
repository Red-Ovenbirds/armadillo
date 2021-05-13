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
  var value = true;
  @override
  void initState() {
    super.initState();
    var myQuestions = buildQuestions();
    controller = ArmadilloEditingController(
        initialData: [
          myQuestions[0]
        ],
        trailPlan: (questions) {
          if (questions.last.id == myQuestions.last.id) {
            return null;
          }
          return myQuestions[questions.length];
        },
        trailEnded: (questions) {
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

  List<Question> buildQuestions() {
    return <Question>[
      Question(
        id: "1",
        label: "Pergunta 1",
        options: ListOptions(list: ["a", "b", "c"]),
        answer: Answer(value: "a"),
      ),
      Question(
        id: "2",
        label: "Pergunta 2",
        questionType: QuestionType.selectDropdown,
        options: ListOptions(list: [1, "b", 3]),
      ),
      Question(
        id: "3",
        label: "Pergunta 3",
        questionType: QuestionType.select,
      ),
      Question(
        id: "4",
        label: "Pergunta 4",
        questionType: QuestionType.select,
        options: SelectOptions(
          falseLabel: "Não, obrigado.",
          trueLabel: "Sim, obrigado.",
        ),
      ),
      Question(
        id: "5",
        label: "Pergunta 5",
        questionType: QuestionType.checklist,
        options: ListOptions(list: ["a", "b", 5.6, "d"]),
      ),
      Question(
        id: "6",
        label: "Pergunta 6",
        questionType: QuestionType.integer,
      ),
      Question(
        id: "7",
        label: "Pergunta 7",
        questionType: QuestionType.integer,
        onTapInfoIcon: (context) {showDialog(context: context, builder: (context) => Dialog(child: Text("clicou em info"),));}
      ),
      Question(
        id: "8",
        label: "Pergunta 8",
        questionType: QuestionType.floatNumber,
      ),
      Question(
        id: "9",
        label: "Pergunta 8",
        questionType: QuestionType.freeText,
      ),
    ];
  }
}
