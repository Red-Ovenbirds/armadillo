import 'package:armadillo/index.dart';
import 'package:flutter/material.dart';

class ArmadilloEditingController with ChangeNotifier {
  List<Question> questions = [];
  final TrailPlan trailPlan;
  Function(Question, dynamic) _questionAnswered;
  Function(Question, int) _questionTapped;
  Function(List<Question>) _trailEnded;

  ArmadilloEditingController(this.trailPlan, 
      {List<Question> initialData,
      Function(Question, dynamic) questionAnswered,
      Function(Question, int) questionTapped,
      Function(List<Question>) trailEnded}) {
    this.questions = initialData;
    this._questionAnswered = questionAnswered;
    this._questionTapped = questionTapped;
    this._trailEnded = trailEnded;
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
    if (question != null) {
      this.questions.add(question);
    } else if (this._trailEnded != null) {
      this._trailEnded(this.questions);
    }
    notifyListeners();
  }

  answerLastQuestion(answer) {
    this.questions.last.answer = answer;
    if (_questionAnswered != null) {
      _questionAnswered(this.questions.last, answer);
    }
    addQuestion(trailPlan(this.questions));
  }
}
