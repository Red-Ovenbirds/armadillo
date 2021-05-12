abstract class Options {
  dynamic get options;
}

class ListOptions extends Options {
  final List<dynamic> list = List<dynamic>();

  @override
  List<dynamic> get options => list;

  ListOptions({List list}) {
    if (list != null) this.list.addAll(list);
  }

  @override
  String toString() {
    return list.toString();
  }
}
