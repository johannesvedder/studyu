import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyou_core/models/models.dart';
import 'package:studyou_core/util/localization.dart';

import '../../widgets/question/questionnaire_editor.dart';

class QuestionnaireTaskEditorSection extends StatefulWidget {
  final QuestionnaireTask task;

  const QuestionnaireTaskEditorSection({@required this.task, Key key}) : super(key: key);

  @override
  _QuestionnaireTaskEditorState createState() => _QuestionnaireTaskEditorState();
}

class _QuestionnaireTaskEditorState extends State<QuestionnaireTaskEditorSection> {
  void _addQuestion() {
    setState(() {
      widget.task.questions.questions.add(BooleanQuestion.designerDefault());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      QuestionnaireEditor(questionnaire: widget.task.questions, questionTypes: Question.questionTypes.keys.toList()),
      RaisedButton.icon(
          onPressed: _addQuestion,
          icon: Icon(Icons.add),
          color: Colors.green,
          label: Text(Nof1Localizations.of(context).translate('add_question')))
    ]);
  }
}
