import 'dart:collection';

import 'package:armadillo/src/node_lister/question_widget.dart';
import 'package:armadillo/src/node_lister/trail/answer_question.dart';
import 'package:armadillo/src/node_lister/trail/question.dart';
import 'package:flutter/material.dart';

class NodeLister extends StatefulWidget {
  LinkedHashMap<Question, AnswerQuestion> shownNodes;

  NodeLister({@required this.shownNodes});

  State createState() => NodeListerState();
}

class NodeListerState extends State<NodeLister> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: widget.shownNodes.length,
          itemBuilder: (context, index) {
            var answer = widget.shownNodes.values.toList()[index];
            var node = widget.shownNodes.keys.toList()[index];
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: buildNodeWidget(node, answer, index));
          }),
    );
  }

  Widget buildNodeWidget(Question node, AnswerQuestion answer, int index) {
    return QuestionWidget(
        question: node,
        answer: answer,
        index: index,
        didChooseAnswer: (index, answer) {
          setState(() => widget.shownNodes[node] = answer);
        },
        didTapCard: (index) => setState(() {
              List<Question> list = widget.shownNodes.keys.toList();
              widget.shownNodes.removeWhere((node, answer) {
                return list.indexOf(node) > index;
              });
            }));
  }
}
