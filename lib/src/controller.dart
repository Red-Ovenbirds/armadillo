import 'package:armadillo/src/question.dart';
import 'package:flutter/material.dart';

class ArmadilloEditingController with ChangeNotifier {
  List<Question> questions = [];
  Function(Question, dynamic) _questionAnswered;
  Function(Question, int) _questionTapped;

  ArmadilloEditingController({List<Question> initialData,
      Function(Question, dynamic) questionAnswered, questionTapped}) {
    this.questions = initialData;
    this._questionAnswered = questionAnswered;
    this._questionTapped = questionTapped;
  }

  updateEntry(int index, Question questions) {
    this.questions[index] = questions;
  }

  questionTapped(int index) {
    if (_questionTapped != null) {
      _questionTapped(this.questions[index], index);
    } else {
      returnToQuestion(index);
    }
  }

  returnToQuestion(int index) {
    this.questions.removeRange(index + 1, this.questions.length);
    notifyListeners();
  }

  addQuestion(Question question) {
    this.questions.add(question);
    notifyListeners();
  }

  answerLastQuestion(answer) {
    this.questions.last.answer = answer;
    if (_questionAnswered != null) {
      _questionAnswered(this.questions.last, answer);
    }
  }
}
