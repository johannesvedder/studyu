import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:studyou_core/models/questionnaire/questionnaire_models.dart';
import 'package:studyou_core/models/questionnaire/questions/slider_question.dart';

import '../../widgets/question/annotated_scale_question_editor_section.dart';
import '../../widgets/question/visual_analogue_question_editor_section.dart';

class SliderQuestionEditorSection extends StatefulWidget {
  final SliderQuestion question;

  const SliderQuestionEditorSection({@required this.question, Key key}) : super(key: key);

  @override
  _SliderQuestionEditorSectionState createState() => _SliderQuestionEditorSectionState();
}

class _SliderQuestionEditorSectionState extends State<SliderQuestionEditorSection> {
  final GlobalKey<FormBuilderState> _editFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final questionBody = _buildQuestionBody();
    return Column(
      children: [
        FormBuilder(
            key: _editFormKey,
            autovalidate: true,
            // readonly: true,
            child: Column(children: <Widget>[
              FormBuilderTextField(
                  onChanged: _saveFormChanges,
                  name: 'minimum',
                  decoration: InputDecoration(labelText: 'Minimum'),
                  initialValue: widget.question.minimum.toString()),
              FormBuilderTextField(
                  onChanged: _saveFormChanges,
                  name: 'maximum',
                  decoration: InputDecoration(labelText: 'Maximum'),
                  initialValue: widget.question.maximum.toString()),
              FormBuilderTextField(
                  onChanged: _saveFormChanges,
                  name: 'initial',
                  decoration: InputDecoration(labelText: 'Initial'),
                  initialValue: widget.question.initial.toString()),
              FormBuilderTextField(
                  onChanged: _saveFormChanges,
                  name: 'step',
                  decoration: InputDecoration(labelText: 'Step'),
                  initialValue: widget.question.step.toString())
            ])),
        if (questionBody != null) questionBody
      ],
    );
  }

  Widget _buildQuestionBody() {
    switch (widget.question.runtimeType) {
      case VisualAnalogueQuestion:
        return VisualAnalogueQuestionEditorSection(question: widget.question);
      case AnnotatedScaleQuestion:
        return AnnotatedScaleQuestionEditorSection(question: widget.question);
      default:
        return null;
    }
  }

  void _saveFormChanges(value) {
    _editFormKey.currentState.save();
    if (_editFormKey.currentState.validate()) {
      setState(() {
        widget.question.minimum = double.parse(_editFormKey.currentState.value['minimum']);
        widget.question.maximum = double.parse(_editFormKey.currentState.value['maximum']);
        widget.question.initial = double.parse(_editFormKey.currentState.value['initial']);
        widget.question.step = double.parse(_editFormKey.currentState.value['step']);
      });
    }
  }
}
