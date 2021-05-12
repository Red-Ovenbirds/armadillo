import 'package:flutter/material.dart';

import 'index.dart';

class Question {
  final String id;
  final QuestionType questionType;
  final String label;
  final Function(BuildContext) onTapInfoIcon;
  Answer answer;
  Options options;

  Question(
      {@required this.id,
      this.questionType = QuestionType.selectList,
      this.label = "",
      this.answer,
      this.onTapInfoIcon,
      this.options}) {
    if (questionType == QuestionType.select) {
      if (options.runtimeType != SelectOptions)
        options = SelectOptions();
    }
    else if (questionType == QuestionType.integer) {
      if (options == null || options.runtimeType != IntegerOptions)
      options = IntegerOptions();
    }
    else {
      if(options == null || options.runtimeType != ListOptions)
        options = ListOptions();
    }
  }
}

enum QuestionType {
  selectList,
  selectDropdown,
  select,
  checklist,
  integer,
  freeText,
}

class SelectOptions extends Options {
  final String trueLabel;
  final String falseLabel;

  @override
  List<String> get options => this.toList();

  SelectOptions({
    this.trueLabel = "Sim",
    this.falseLabel = "Não",
  });

  List<String> toList() {
    return [trueLabel, falseLabel];
  }

  bool value(String label) {
    if (label == trueLabel) return true;
    if (label == falseLabel) return false;
    return null;
  }
}

class SelectAnswer extends Answer {
  @override
  bool _value;

  @override
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

class ChecklistAnswer extends Answer {
  List<bool> _valueList = List<bool>();
  List<String> _labelList;

  @override
  List<bool> get value {
    return _valueList;
  }

  ChecklistAnswer({
    @required List<bool> value,
    List<String> labelList,
  }) {
    _valueList.addAll(value);
    if (labelList != null) {
      _labelList = List<String>();
      _labelList.addAll(labelList);
    }
  }

  void changeValue(int index, {bool value}) {
    _valueList[index] = value ?? !_valueList[index];
  }

  @override
  String toString() {
    if (_labelList == null) return "Respondido";
    List<String> labelsSelectedList = List<String>();
    String string = "Selecionado: ";

    for (int i = 0; i < _labelList.length; i++)
      if (_valueList[i]) labelsSelectedList.add(_labelList[i]);

    for (int i = 0; i < labelsSelectedList.length - 1; i++)
      string += "${labelsSelectedList[i]}, ";
    string += "${labelsSelectedList.last}";

    return string != "Selecionado: " ? string : "Respondido";
  }
}

class IntegerOptions extends Options {
  final int minimum;
  final int maximum;
  final String error;
  final String errorUnderFlow;
  final String errorOverFlow;

  @override
  List<int> get options =>
      List.generate(maximum - minimum + 1, (index) => index + minimum);

  IntegerOptions({
    this.minimum,
    this.maximum,
    this.error,
    this.errorUnderFlow,
    this.errorOverFlow,
  });
}
