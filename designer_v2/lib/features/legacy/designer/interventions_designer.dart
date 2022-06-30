import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/features/legacy/designer/help_wrapper.dart';
import 'package:studyu_designer_v2/features/legacy/designer/app_state.dart';

import '../widgets/intervention/intervention_editor.dart';
import '../widgets/util/designer_add_button.dart';

class InterventionsDesigner extends StatefulWidget {
  @override
  _InterventionsDesignerState createState() => _InterventionsDesignerState();
}

class _InterventionsDesignerState extends State<InterventionsDesigner> {
  late List<Intervention> _interventions;

  void _addIntervention() {
    setState(() {
      _interventions.add(Intervention.withId());
    });
    context.read<AppState>().updateDelegate();
  }

  void _removeIntervention(int index) {
    setState(() {
      _interventions.removeAt(index);
    });
    context.read<AppState>().updateDelegate();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<AppState>().draftStudy == null) return Container();
    _interventions = context.watch<AppState>().draftStudy!.interventions;
    return DesignerHelpWrapper(
      helpTitle: AppLocalizations.of(context)!.interventions_help_title,
      helpText: AppLocalizations.of(context)!.interventions_help_body,
      studyPublished: context.watch<AppState>().draftStudy!.published,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ..._interventions
                          .asMap()
                          .entries
                          .map(
                            (entry) => InterventionEditor(
                              key: UniqueKey(),
                              intervention: entry.value,
                              remove: () => _removeIntervention(entry.key),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 200)
                    ],
                  ),
                ),
              ),
            ),
          ),
          DesignerAddButton(label: Text(AppLocalizations.of(context)!.add_intervention), add: _addIntervention)
        ],
      ),
    );
  }
}
