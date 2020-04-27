import 'package:armadillo/src/controller.dart';
import 'package:armadillo/src/node_lister/node_lister.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Armadillo extends StatefulWidget {
  final ArmadilloEditingController controller;

  const Armadillo({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArmadilloState();
}

class _ArmadilloState extends State<Armadillo> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => widget.controller != null
            ? widget.controller
            : ArmadilloEditingController(),
        child: NodeLister());
  }
}
