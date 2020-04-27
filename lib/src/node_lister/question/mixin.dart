import 'package:armadillo/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin QuestionWidgetMixin {
  
  void answer(BuildContext context, dynamic answer) {
    final editingController = Provider.of<ArmadilloEditingController>(context, listen: false);
    editingController.answerLastQuestion(answer);
  }

  Question question(BuildContext context) {
    return Provider.of<Question>(context, listen: false);
  }

  int index(BuildContext context) {
    return Provider.of<int>(context, listen: false);
  }

}