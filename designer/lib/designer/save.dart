import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:provider/provider.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer/designer/help_wrapper.dart';
import 'package:studyu_designer/models/app_state.dart';

class Save extends StatefulWidget {
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  Study _draftStudy;

  @override
  void initState() {
    super.initState();
    _draftStudy = context.read<AppState>().draftStudy;
  }

  Future<Study> _publishStudy(BuildContext context, Study study) async {
    _draftStudy.published = true;
    final publishingAccepted =
        await showDialog<bool>(context: context, builder: (_) => PublishAlertDialog(studyTitle: _draftStudy.title));
    if (publishingAccepted) {
      final savedStudy = await study.save();
      if (savedStudy != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_draftStudy.title} ${AppLocalizations.of(context).was_saved_and_published}')));
        return savedStudy;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_draftStudy.title} ${AppLocalizations.of(context).failed_saving}')));
      }
    }
    return null;
  }

  Future<Study> _saveDraft(Study study) async {
    final savedStudy = study.save();
    if (savedStudy != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_draftStudy.title} ${AppLocalizations.of(context).was_saved_as_draft}')));
      return savedStudy;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${_draftStudy.title} ${AppLocalizations.of(context).failed_saving}')));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<AppState>().draftStudy == null) return Container();
    final theme = Theme.of(context);
    return DesignerHelpWrapper(
        helpTitle: AppLocalizations.of(context).save_help_title,
        helpText: AppLocalizations.of(context).save_help_body,
        studyPublished: _draftStudy.published,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppLocalizations.of(context).save, style: theme.textTheme.headline6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                        onPressed: () async {
                          final newStudy = await _saveDraft(_draftStudy);
                          if (newStudy != null) context.read<AppState>().openNewStudy(newStudy);
                        },
                        icon: Icon(Icons.save),
                        label: Text(AppLocalizations.of(context).save_draft, style: TextStyle(fontSize: 30))),
                    SizedBox(width: 16),
                    OutlinedButton.icon(
                        onPressed: () async {
                          final newStudy = await _publishStudy(context, _draftStudy);
                          if (newStudy != null) context.read<AppState>().openNewStudy(newStudy);
                        },
                        icon: Icon(Icons.publish),
                        label: Text(AppLocalizations.of(context).publish_study, style: TextStyle(fontSize: 30))),
                  ],
                ),
                SizedBox(height: 80),
                JSONExportSection(study: _draftStudy),
              ],
            ),
          ),
        ));
  }
}

class JSONExportSection extends StatefulWidget {
  final Study study;

  const JSONExportSection({@required this.study, Key key}) : super(key: key);

  @override
  _JSONExportSectionState createState() => _JSONExportSectionState();
}

class _JSONExportSectionState extends State<JSONExportSection> {
  bool _showDebugOutput = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(AppLocalizations.of(context).debug_output, style: theme.textTheme.headline6),
        CheckboxListTile(
            title: Text(AppLocalizations.of(context).show_debug_output),
            value: _showDebugOutput,
            onChanged: (val) => setState(() => _showDebugOutput = val)),
        if (_showDebugOutput)
          Column(children: [
            Row(
              children: [
                Text(AppLocalizations.of(context).study_model_in_json),
                SizedBox(width: 8),
                OutlinedButton.icon(
                    onPressed: () async {
                      await FlutterClipboard.copy(prettyJson(widget.study.toJson()));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).copied_json)));
                    },
                    icon: Icon(Icons.copy),
                    label: Text(AppLocalizations.of(context).copy)),
              ],
            ),
            SizedBox(height: 8),
            JsonViewerWidget(widget.study.toJson()),
          ])
      ],
    );
  }
}

class PublishAlertDialog extends StatelessWidget {
  final String studyTitle;

  const PublishAlertDialog({@required this.studyTitle}) : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).lock_and_publish),
      content: RichText(
        text: TextSpan(style: TextStyle(color: Colors.black), children: [
          TextSpan(text: 'The study '),
          TextSpan(
              text: studyTitle, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          TextSpan(text: AppLocalizations.of(context).really_want_to_publish),
        ]),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.publish),
          style: ElevatedButton.styleFrom(primary: Colors.green, elevation: 0),
          label: Text('${AppLocalizations.of(context).publish} $studyTitle'),
        )
      ],
    );
  }
}