import 'package:armadillo/index.dart';
import 'package:armadillo/src/node_lister/question/mixin.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Function(int) didTapCard;

  QuestionWidget({this.didTapCard});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with TickerProviderStateMixin, QuestionWidgetMixin {
  AnimationController _animationController;
  Animation<double> _elevationTween;
  Animation<double> _fadeTween;
  Animation _colorTween;

  TextEditingController _controllerText;
  GlobalKey<FormState> _formKey;
  Answer _answer;

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

    _animationController.value =
        this.question(context).answer == null ? 0.0 : 1.0;
    _elevated = this.question(context).answer != null;

    _elevationTween = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.decelerate));
    _fadeTween = Tween(begin: 1.0, end: 0.0).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });

    if (this.question(context).questionType == QuestionType.integer ||
        this.question(context).questionType == QuestionType.floatNumber ||
        this.question(context).questionType == QuestionType.freeText) {
      _formKey = GlobalKey<FormState>();
      _controllerText = TextEditingController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorTween = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Colors.white,
    ).animate(CurvedAnimation(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          question == null ? '' : question.label,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      question.actions != null && question.actions.isNotEmpty
                        ? Row(children: question.actions,)
                        : null,
                      question.onTapInfoIcon != null
                        ? IconButton(
                            icon: Icon(
                              Icons.info,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => question.onTapInfoIcon(context),
                          )
                        : null
                    ].where((_) => _ != null).cast<Widget>().toList(),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    style: subtitleStyle(),
                    child: Text(question.answer == null
                        ? ''
                        : question.answer.toString()),
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
    switch (this.question(context).questionType) {
      case QuestionType.selectList:
        return _buildList(this.question(context).options.options, answerSelected);
      case QuestionType.selectDropdown:
        return _buildDropdown();
      case QuestionType.select:
        SelectOptions selectOptions = this.question(context).options;
        return _buildList(selectOptions.options, (answer) {
          answerSelected(SelectAnswer(
              value: selectOptions.value(answer.value),
              label: answer.toString()));
        });
      case QuestionType.checklist:
        return _buildChecklist();
      case QuestionType.integer:
        return _buildIntegerForm();
      case QuestionType.floatNumber:
        return _buildFloatNumberForm();
      case QuestionType.freeText:
        return _buildFreeTextForm();
      default:
        return null;
    }
  }

  Widget _buildList(List list, Function(Answer) onPressed) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          dynamic option = list[index];
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
                        onPressed: () => onPressed(Answer(value: option)),
                        color: Theme.of(context).accentColor,
                        child: Text(
                          option.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void answerSelected(Answer answer) {
    _elevated = true;
    _animationController.forward().whenCompleteOrCancel(() {
      this.answer(context, answer);
    });
  }

  Widget _buildChecklist() {
    List<Widget> children = List<Widget>();
    List options = this.question(context).options.options;
    ChecklistAnswer answer;

    if(_answer == null)
      if(this.question(context).answer == null || this.question(context).answer.runtimeType != ChecklistAnswer) 
        _answer = ChecklistAnswer(value: options.map((_) => false).toList().cast<bool>(), labelList: options.map((_) => _.toString()).toList().cast<String>() );
      else
        _answer = this.question(context).answer;
    answer = _answer;
    
    for(int i=0; i<options.length; i++)
      children.add( Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 44,
          child: Row(
            children: <Widget>[
              Checkbox(
                value: answer.value[i],
                onChanged: (bool newValue) {
                  setState( () {
                    answer.changeValue(i, value: newValue);
                    _answer = answer;
                  });
                },
              ),
              Text(options[i].toString()),
            ],
          ),
        ),
      ));

    children.add(
      Padding(
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
                    onPressed: () => answerSelected(_answer),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Próximo",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(children: children);
  }

  Widget _buildDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: Colors.white,
        child: DropdownButton<dynamic>(
          isExpanded: true,
          underline: Container(),
          value: this.question(context).answer,
          onChanged: (newValue) => answerSelected(Answer(value: newValue)),
          items: this
              .question(context)
              .options
              .options
              .map<DropdownMenuItem<dynamic>>((option) {
            return DropdownMenuItem<dynamic>(
              value: option,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(option.toString()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFreeTextForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextFormField(
              onEditingComplete: () {
                if (_formKey.currentState.validate()) {
                  answerSelected(Answer(value: _controllerText.text));
                }
              },
              controller: _controllerText,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
                ),
              ),
              validator: (value) => value == null || value.isEmpty ? "Preencha o campo" : null,
              keyboardType: TextInputType.text,
            ),
          ),
        ));
  }

  Widget _buildIntegerForm() {
    return Form(
      key: _formKey,
      child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TextFormField(
          onEditingComplete: () {
            if(_formKey.currentState.validate()) {
              answerSelected(Answer(value: int.parse(_controllerText.text, radix: 10)));
            }
          },
          controller: _controllerText,
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(),
            ),
          ),
          validator: (value) {
            int number = int.parse(value, radix: 10);
            IntegerOptions options = this.question(context).options;

            if(options.minimum != null && number < options.minimum)
              return options.errorUnderFlow ?? options.error ?? "Valor inferior a ${options.minimum}.";
            if(options.maximum != null && number > options.maximum)
              return options.errorOverFlow ?? options.error ?? "Valor superior a ${options.maximum}.";
            
            return null;
          },
          keyboardType: TextInputType.number,
        ),
      ),
    ));
  }

  Widget _buildFloatNumberForm() {
    return Form(
      key: _formKey,
      child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TextFormField(
          onEditingComplete: () {
            if(_formKey.currentState.validate()) {
              answerSelected(Answer(value: double.parse(_controllerText.text)));
            }
          },
          controller: _controllerText,
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(),
            ),
          ),
          validator: (value) {
            try {
              double number = double.parse(value);
              FloatNumberOptions options = this.question(context).options;

              if(options.minimum != null && number < options.minimum)
                return options.errorUnderFlow ?? options.error ?? "Valor inferior a ${options.minimum}.";
              if(options.maximum != null && number > options.maximum)
                return options.errorOverFlow ?? options.error ?? "Valor superior a ${options.maximum}.";
              
              return null;
            } catch (e) {
              return "Insira um número válido.";
            }
          },
          keyboardType: TextInputType.number,
        ),
      ),
    ));
  }
}
