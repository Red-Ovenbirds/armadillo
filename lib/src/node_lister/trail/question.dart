import 'options.dart';

class Question {
  QuestionType questionType;
  String label;
  String imageInfo;
  Options options;
}

enum QuestionType {
  SelectString, SelectInt, Select
}