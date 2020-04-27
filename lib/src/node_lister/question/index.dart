import 'package:armadillo/src/node_lister/question/mixin.dart';
import 'package:armadillo/src/question.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Function(int) didTapCard;

  QuestionWidget(
      {this.didTapCard});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with TickerProviderStateMixin, QuestionWidgetMixin {
  AnimationController _animationController;
  Animation<double> _elevationTween;
  Animation<double> _fadeTween;
  Animation _colorTween;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  var _elevated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animationController.value = this.question(context).answer == null ? 0.0 : 1.0;
    _elevated = this.question(context).answer != null;

    _elevationTween = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.decelerate));
    _fadeTween = Tween(begin: 1.0, end: 0.0).animate(_animationController);


    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
        _colorTween = ColorTween(begin: Theme.of(context).scaffoldBackgroundColor, end: Colors.white)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCubic));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: buildQuestionCard(context),
            ),
          ],
        ),
      ],
    );
  }

  Card buildQuestionCard(BuildContext context) {
    final question = this.question(context);
    return Card(
        color: _colorTween.value,
        elevation: _elevationTween.value,
        child: InkWell(
            onTap: _elevated ? cardTapped : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    question == null ? '' : question.label,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    style: subtitleStyle(),
                    child: Text(
                        question.answer == null ? '' : question.answer.toString()),
                  ),
                  buildAnswersContainer()
                ],
              ),
            )));
  }

  void cardTapped() {
    _elevated = false;
    _animationController.reverse().whenCompleteOrCancel(() {
      this.widget.didTapCard(this.index(context));
    });
  }

  TextStyle subtitleStyle() {
    if (_elevated) {
      return TextStyle(
          fontSize: 14,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold);
    }

    return TextStyle(
      fontSize: 0,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    );
  }

  Widget buildAnswersContainer() {
    return AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        child: Container(
          child: _elevated && _fadeTween.value == 0
              ? null
              : FadeTransition(
                  opacity: _fadeTween,
                  child: Column(
                    children: <Widget>[buildForm()],
                  ),
                ),
        ));
  }

  Widget buildForm() {
    //TODO: Switch com os tipos de pergunta
    //exibindo widget diferente para cada caso
    //este é o caso selectString
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: this.question(context).options.length,
        itemBuilder: (context, index) {
          String option = this.question(context).options[index];
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: SizedBox(
                  height: 44,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            onPressed: () => answerSelected(option),
                            color: Theme.of(context).accentColor,
                            child: Text(
                              option,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )));
        });
  }

  void answerSelected(dynamic answer) {
    _elevated = true;
    _animationController.forward().whenCompleteOrCancel(() {
      this.answer(context, answer);
    });
  }
}
