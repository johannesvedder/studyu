import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nof1_models/models/models.dart';
import 'package:provider/provider.dart';

import '../database/daos/study_dao.dart';
import '../routes.dart';
import '../study_onboarding/app_state.dart';
import '../util/localization.dart';

class StudySelectionScreen extends StatelessWidget {
  Future<void> navigateToStudyOverview(BuildContext context, Study selectedStudy) async {
    context.read<AppModel>().selectedStudy = selectedStudy;
    Navigator.pushNamed(context, Routes.studyOverview);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Nof1Localizations.of(context).translate('study_selection')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  Nof1Localizations.of(context).translate('study_selection_description'),
                  style: theme.textTheme.headline5,
                ),
              ),
            ),
            FutureBuilder(
              future: StudyDao().getAllStudies(),
              builder: (_context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final Study currentStudy = snapshot.data[index];
                          return ListTile(
                              contentPadding: EdgeInsets.all(16),
                              onTap: () {
                                navigateToStudyOverview(context, currentStudy);
                              },
                              title: Center(
                                  child: Text(currentStudy.title,
                                      style: theme.textTheme.headline6.copyWith(color: theme.primaryColor))),
                              subtitle: Center(child: Text(currentStudy.description)),
                              leading: Icon(MdiIcons.fromString(currentStudy.iconName ?? 'accountHeart'),
                                  color: theme.primaryColor));
                        })
                    : CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
