import 'package:flutter/material.dart';

class Question {
  final String id;
  final QuestionType questionType;
  final String label;
  final bool showsInfoIcon;
  dynamic answer;
  dynamic options;

  Question(
      {@required this.id, this.questionType = QuestionType.selectList,
      this.label = "",
      this.answer,
      this.showsInfoIcon = false,
      this.options = const []}) {
        if(questionType == QuestionType.select && options.runtimeType != SelectOptions)
          options = SelectOptions();
        else if(questionType == QuestionType.interger && options.runtimeType != IntergerOptions)
          options = IntergerOptions();
    }
}

enum QuestionType { selectList, selectDropdown, select, checklist, interger }

class SelectOptions {
  final String trueLabel;
  final String falseLabel;

  SelectOptions({
    this.trueLabel = "Sim",
    this.falseLabel = "Não",
  });

  List<String> toList() {
    return [trueLabel, falseLabel];
  }

  bool value(String label) {
    if(label == trueLabel)
      return true;
    if(label == falseLabel)
      return false;
    return null;
  }
}

class SelectAnswer {
  bool _value;
  bool get value {
    return _value;
  }
  String _label;

  SelectAnswer({
    @required bool value,
    String label,
  }) {
    _value = value;
    _label = label;
  }

  @override
  String toString() {
    return _label ?? (_value == true ? "Sim" : "Não");
  }
}

class ChecklistAnswer {
  List<bool> _valueList = List<bool>();
  List<String> _labelList;
  List<bool> get value {
    return _valueList;
  }

  ChecklistAnswer({
    @required List<bool> value,
    List<String> labelList,
  }) {
    _valueList.addAll(value);
    if(labelList != null) {
      _labelList = List<String>();
      _labelList.addAll(labelList);
    }
  }

  void changeValue(int index, {bool value}) {
    _valueList[index] = value ?? !_valueList[index];
  }

  @override
  String toString() {
    if(_labelList == null)
      return "Respondido";
    String string = "Selecionado: ";

    for(int i=0; _labelList[i] != _labelList.last; i++)
      if(_valueList[i])
        string += "${_labelList[i].toString()}, ";
    if(_valueList[_labelList.length-1])
      string += "${_labelList.last.toString()}";

    return string != "Selecionado: " ? string : "Respondido";
  }
}

class IntergerOptions {
  final int minimum;
  final int maximum;
  final String error;
  final String errorUnderFlow;
  final String errorOverFlow;

  IntergerOptions({
    this.minimum,
    this.maximum,
    this.error,
    this.errorUnderFlow,
    this.errorOverFlow,
  });
}