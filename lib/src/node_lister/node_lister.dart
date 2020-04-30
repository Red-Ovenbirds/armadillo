import 'package:armadillo/src/controller.dart';
import 'package:armadillo/src/node_lister/question/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NodeLister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArmadilloEditingController>(
        builder: (context, controller, child) {
      return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: MultiProvider(
                    providers: [
                      Provider.value(value: controller.questions[index]),
                      //Index is also being provided because some
                      //TaiperEditingController methods require it
                      Provider.value(value: index)
                    ],
                    child: QuestionWidget(
                        didTapCard: (index) =>
                            controller.questionTapped(index))));
          });
    });
  }
}
