import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:studyou_core/models/models.dart';
import 'package:studyou_core/util/localization.dart';

class VisualAnalogueQuestionEditorSection extends StatefulWidget {
  final VisualAnalogueQuestion question;

  const VisualAnalogueQuestionEditorSection({@required this.question, Key key}) : super(key: key);

  @override
  _VisualAnalogueQuestionEditorSectionState createState() => _VisualAnalogueQuestionEditorSectionState();
}

class _VisualAnalogueQuestionEditorSectionState extends State<VisualAnalogueQuestionEditorSection> {
  final GlobalKey<FormBuilderState> _editFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _editFormKey,
        autovalidate: true,
        // readonly: true,
        child: Column(children: <Widget>[
          FormBuilderTextField(
              onChanged: _saveFormChanges,
              name: 'minimumAnnotation',
              decoration: InputDecoration(labelText: Nof1Localizations.of(context).translate('minimum_annotation')),
              initialValue: widget.question.minimumAnnotation),
          FormBuilderColorPickerField(
              onChanged: _saveFormChanges,
              name: 'minimumColor',
              showCursor: true,
              decoration: InputDecoration(labelText: Nof1Localizations.of(context).translate('minimum_color')),
              initialValue: widget.question.minimumColor),
          FormBuilderTextField(
              onChanged: _saveFormChanges,
              name: 'maximumAnnotation',
              decoration: InputDecoration(labelText: Nof1Localizations.of(context).translate('maximum_annotation')),
              initialValue: widget.question.maximumAnnotation),
          FormBuilderColorPickerField(
              onChanged: _saveFormChanges,
              name: 'maximumColor',
              showCursor: true,
              decoration: InputDecoration(labelText: Nof1Localizations.of(context).translate('maximum_color')),
              initialValue: widget.question.maximumColor)
        ]));
  }

  void _saveFormChanges(value) {
    _editFormKey.currentState.save();
    if (_editFormKey.currentState.validate()) {
      setState(() {
        widget.question.minimumAnnotation = _editFormKey.currentState.value['minimumAnnotation'];
        widget.question.minimumColor = _editFormKey.currentState.value['minimumColor'];
        widget.question.maximumAnnotation = _editFormKey.currentState.value['maximumAnnotation'];
        widget.question.maximumColor = _editFormKey.currentState.value['maximumColor'];
      });
    }
  }
}
