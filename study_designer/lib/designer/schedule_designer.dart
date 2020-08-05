import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/designer_state.dart';

class ScheduleDesigner extends StatefulWidget {
  @override
  _ScheduleDesignerState createState() => _ScheduleDesignerState();
}

class _ScheduleDesignerState extends State<ScheduleDesigner> {
  LocalStudy _draftStudy;

  @override
  void initState() {
    super.initState();
    _draftStudy = context.read<DesignerModel>().draftStudy;
  }

  final GlobalKey<FormBuilderState> _editFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _editFormKey,
              autovalidate: true,
              // readonly: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                      attribute: 'title',
                      maxLength: 40,
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: _draftStudy.title),
                  FormBuilderTextField(
                      attribute: 'description',
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: _draftStudy.description),
                  MaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      _editFormKey.currentState.save();
                      if (_editFormKey.currentState.validate()) {
                        setState(() {
                          _draftStudy
                            ..title = _editFormKey.currentState.value['title']
                            ..description = _editFormKey.currentState.value['description'];
                        });
                        print('saved');
                        print(_draftStudy.studyDetails.interventions);
                        // TODO: show dialog "saved"
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}