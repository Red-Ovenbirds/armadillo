class Question {
  final QuestionType questionType;
  final String label;
  final bool showsInfoIcon;
  dynamic answer;
  List<dynamic> options;

  Question(
      {this.questionType = QuestionType.selectString,
      this.label = "",
      this.showsInfoIcon = false,
      this.options = const []});
}

enum QuestionType { selectString, selectInt, select }
