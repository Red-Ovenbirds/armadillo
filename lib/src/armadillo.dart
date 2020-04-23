
import 'dart:collection';

import 'package:armadillo/armadillo.dart';
import 'package:armadillo/src/node_lister/node_lister.dart';
import 'package:armadillo/src/node_lister/trail/answer_question.dart';
import 'package:armadillo/src/node_lister/trail/question.dart';
import 'package:flutter/material.dart';

class Armadillo extends StatefulWidget{
  List<Trail> trailList;

  Armadillo({@required this.trailList});

  @override
  State<StatefulWidget> createState() => _ArmadilloState();
}

class _ArmadilloState extends State<Armadillo> {
  LinkedHashMap<Question, AnswerQuestion> shownQuestion;

  @override
  void initState () {
    super.initState();

    shownQuestion = LinkedHashMap<Question, AnswerQuestion>();
    widget.trailList.forEach( (trail) {
      shownQuestion[trail.question] = trail.answerQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NodeLister(shownNodes: shownQuestion,);
  }
}