class Answer {
  dynamic _value;

  dynamic get value => _value;
  
  Answer({dynamic value}) {
    _value = value;
  }

  @override
  String toString() {
    return value.toString();
  }
}

