//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../database/daos/study_dao.dart';
import '../database/models/models.dart';
import '../onboarding/eligibility_check.dart';

class StudySelectionScreen extends StatelessWidget {
  void navigateToEligibilityCheck(BuildContext context, Study selectedStudy) async {
    final isEligible = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EligibilityCheckScreen(
                  study: selectedStudy,
                  route: ModalRoute.of(context),
                )));
    if (isEligible) {
      print('Patient is eligible');
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('You are not eligible for this study. Please select a different one.'),
        duration: Duration(seconds: 30),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: StudyDao().getAllStudies(),
          builder: (_context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final Study currentStudy = snapshot.data[index];
                      return Center(
                        child: ListTile(
                          onTap: () {
                            navigateToEligibilityCheck(context, currentStudy);
                          },
                          title: Center(child: Text(currentStudy.title)),
                          subtitle: Center(child: Text(currentStudy.description)),
                          leading: currentStudy.id == '2' ? Icon(MdiIcons.cannabis) : Icon(MdiIcons.accountHeart),
                          trailing: currentStudy.id == '2' ? Icon(MdiIcons.glassMugVariant) : Icon(MdiIcons.pill),
                        ),
                      );
                    })
                : CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
