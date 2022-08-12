import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/common_views/async_value_widget.dart';
import 'package:studyu_designer_v2/common_views/container_bounded.dart';
import 'package:studyu_designer_v2/common_views/text_hyperlink.dart';
import 'package:studyu_designer_v2/common_views/text_paragraph.dart';
import 'package:studyu_designer_v2/features/design/common_views/form_array_table.dart';
import 'package:studyu_designer_v2/features/design/interventions/intervention_form_controller.dart';
import 'package:studyu_designer_v2/features/design/study_form_providers.dart';
import 'package:studyu_designer_v2/features/study/study_controller.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';

class StudyDesignInterventionsFormView extends ConsumerWidget {
  const StudyDesignInterventionsFormView(this.studyId, {Key? key})
      : super(key: key);

  final String studyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyControllerProvider(studyId));

    return AsyncValueWidget<Study>(
      value: state.study,
      data: (study) {
        final formViewModel =
        ref.read(interventionsFormViewModelProvider(studyId));
        return ReactiveForm(
          formGroup: formViewModel.form,
          child: BoundedContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextParagraph(
                  text: "Define the different phases of interventions that "
                      "your study participants will go through (once or "
                      "multiple times in a crossover trial design). Each "
                      "intervention consists of one or more treatments "
                      "which are administered during the corresponding phase.\n\n"
                      "If you specify more than two interventions, participants "
                      "are free to choose any two interventions to compare "
                      "when they begin the study.".hardcoded),
                const SizedBox(height: 10.0),
                const Hyperlink(
                  icon: Icons.north_east_rounded,
                  text: "Learn more about N-of-1 trial designs",
                  url: "https://example.com/" // TODO replace link with actual content
                ),
                const SizedBox(height: 24.0),
                ReactiveFormConsumer(
                  // [ReactiveFormConsumer] is needed to to rerender when descendant controls are updated
                  // By default, ReactiveFormArray only updates when adding/removing controls
                    builder: (context, form, child) {
                      return ReactiveFormArray(
                        formArray: formViewModel.interventionsArray,
                        builder: (context, formArray, child) {
                          return FormArrayTable<InterventionFormViewModel>(
                            items: formViewModel.interventionsCollection.formViewModels,
                            onSelectItem: formViewModel.onSelectItem,
                            getActionsAt: (viewModel, _) => formViewModel.availablePopupActions(viewModel),
                            onNewItem: formViewModel.onNewItem,
                            onNewItemLabel: 'Add intervention'.hardcoded,
                            rowTitle: (viewModel) => viewModel.formData?.title ?? 'Missing item title'.hardcoded,
                            sectionTitle: "Intervention phases".hardcoded,
                            sectionTitleDivider: false,
                            emptyIcon: Icons.content_paste_off_rounded,
                            emptyTitle: "No interventions defined".hardcoded,
                            emptyDescription: "You must define at least two interventions to compare.".hardcoded,
                          );
                        },
                      );
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
