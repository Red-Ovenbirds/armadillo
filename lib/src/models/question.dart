class Question {
  final String id;
  final QuestionType questionType;
  final String label;
  final bool showsInfoIcon;
  dynamic answer;
  List<dynamic> options;

  Question(this.id,
      {this.questionType = QuestionType.selectString,
      this.label = "",
      this.answer,
      this.showsInfoIcon = false,
      this.options = const []});
}

enum QuestionType { selectString, selectInt, select }
