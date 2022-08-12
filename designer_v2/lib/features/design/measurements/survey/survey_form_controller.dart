import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_core/core.dart';
import 'package:studyu_designer_v2/constants.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model_collection.dart';
import 'package:studyu_designer_v2/domain/schedule.dart';
import 'package:studyu_designer_v2/domain/study.dart';
import 'package:studyu_designer_v2/features/design/measurements/survey/question/survey_question_form_controller.dart';
import 'package:studyu_designer_v2/features/design/measurements/survey/question/survey_question_form_data.dart';
import 'package:studyu_designer_v2/features/design/measurements/survey/survey_form_data.dart';
import 'package:studyu_designer_v2/features/forms/form_view_model_collection_actions.dart';
import 'package:studyu_designer_v2/repositories/api_client.dart';
import 'package:studyu_designer_v2/routing/router_config.dart';
import 'package:studyu_designer_v2/utils/extensions.dart';
import 'package:studyu_designer_v2/utils/model_action.dart';
import 'package:studyu_designer_v2/utils/riverpod.dart';
import 'package:uuid/uuid.dart';

class MeasurementSurveyFormViewModel
    extends ManagedFormViewModel<MeasurementSurveyFormData>
    implements
        IFormViewModelDelegate<SurveyQuestionFormViewModel>,
        IListActionProvider<SurveyQuestionFormViewModel>,
        IProviderArgsResolver<SurveyQuestionFormViewModel,
            SurveyQuestionFormRouteArgs> {
  MeasurementSurveyFormViewModel({
    required this.study,
    super.delegate,
    super.formData,
  }) {
    hasReminderControl.valueChanges.listen((hasReminder) {
      if (hasReminder != null && !hasReminder) {
        reminderTimeControl.markAsDisabled();
      } else {
        reminderTimeControl.markAsEnabled();
      }
    });
  }

  final Study study;

  // - Form fields

  final FormControl<MeasurementID> measurementIdControl = FormControl(
      validators: [Validators.required], value: const Uuid().v4()); // hidden
  final FormControl<String> surveyTitleControl = FormControl(
      validators: [Validators.required, Validators.minLength(3)],
      value: MeasurementSurveyFormData.kDefaultTitle);
  final FormControl<String> surveyIntroTextControl = FormControl(value: '');
  final FormControl<String> surveyOutroTextControl = FormControl(value: '');

  final FormControl<bool> isTimeRestrictedControl =
      FormControl(validators: [Validators.required], value: false);
  final FormControl<TimeOfDay> restrictedTimeStartControl =
      FormControl(value: const TimeOfDay(hour: 0, minute: 0));
  final FormControl<TimeOfDay> restrictedTimeEndControl =
      FormControl(value: const TimeOfDay(hour: 23, minute: 59));

  final FormControl<bool> hasReminderControl =
      FormControl(validators: [Validators.required], value: false);
  final FormControl<TimeOfDay> reminderTimeControl = FormControl();

  final FormArray surveyQuestionsArray =
      FormArray([], validators: [Validators.minLength(1)]);

  bool get hasReminder => hasReminderControl.value!;
  bool get isTimeRestricted => isTimeRestrictedControl.value!;

  List<TimeOfDay>? get timeRestriction => (isTimeRestricted &&
          restrictedTimeStartControl.value != null &&
          restrictedTimeEndControl.value != null)
      ? [restrictedTimeStartControl.value!, restrictedTimeEndControl.value!]
      : null;

  MeasurementID get measurementId => measurementIdControl.value!;

  late final surveyQuestionFormViewModels = FormViewModelCollection<
      SurveyQuestionFormViewModel,
      SurveyQuestionFormData>([], surveyQuestionsArray);

  List<SurveyQuestionFormViewModel> get surveyQuestionModels =>
      surveyQuestionFormViewModels.formViewModels;

  @override
  late final FormGroup form = FormGroup({
    'measurementId': measurementIdControl, // hidden
    'surveyTitle': surveyTitleControl,
    'surveyIntroText': surveyIntroTextControl,
    'surveyOutroText': surveyOutroTextControl,
    'surveyQuestions': surveyQuestionsArray,
    'isTimeRestricted': isTimeRestrictedControl,
    'restrictedTimeStart': restrictedTimeStartControl,
    'restrictedTimeEnd': restrictedTimeEndControl,
    'hasReminder': hasReminderControl,
    'reminderTime': reminderTimeControl,
  });

  @override
  void setControlsFrom(MeasurementSurveyFormData data) {
    measurementIdControl.value = data.measurementId;
    surveyTitleControl.value = data.title;
    surveyIntroTextControl.value = data.introText ?? '';
    surveyOutroTextControl.value = data.outroText ?? '';

    if (data.surveyQuestionsData != null) {
      final viewModels = data.surveyQuestionsData!
          .map((data) =>
              SurveyQuestionFormViewModel(formData: data, delegate: this))
          .toList();
      surveyQuestionFormViewModels.reset(viewModels);
    }

    isTimeRestrictedControl.value = data.isTimeLocked;
    restrictedTimeStartControl.value = data.timeLockStart?.toTimeOfDay();
    restrictedTimeEndControl.value = data.timeLockEnd?.toTimeOfDay();
    hasReminderControl.value = data.hasReminder;
    reminderTimeControl.value = data.reminderTime?.toTimeOfDay();
  }

  @override
  MeasurementSurveyFormData buildFormData() {
    final data = MeasurementSurveyFormData(
      measurementId: measurementId, // required hidden
      title: surveyTitleControl.value!, // required
      introText: surveyIntroTextControl.value,
      outroText: surveyOutroTextControl.value,
      surveyQuestionsData: surveyQuestionFormViewModels.formData,
      isTimeLocked: isTimeRestrictedControl.value!, // required
      timeLockStart: restrictedTimeStartControl.value?.toStudyUTimeOfDay(),
      timeLockEnd: restrictedTimeEndControl.value?.toStudyUTimeOfDay(),
      hasReminder: hasReminderControl.value!, // required
      reminderTime: reminderTimeControl.value?.toStudyUTimeOfDay(),
    );
    return data;
  }

  String get breadcrumbsTitle {
    final components = [
      study.title,
      formData?.title ?? MeasurementSurveyFormData.kDefaultTitle
    ];
    return components.join(kPathSeparator);
  }

  @override
  Map<FormMode, String> get titles => {
        FormMode.create: breadcrumbsTitle,
        FormMode.edit: breadcrumbsTitle,
      };

  // - IListActionProvider

  // - IListActionProvider

  @override
  List<ModelAction> availableActions(SurveyQuestionFormViewModel model) {
    // TODO: set & propagate FormMode.readonly at root FormViewModel (if needed)
    final isReadonly = formMode == FormMode.readonly;
    final actions = surveyQuestionFormViewModels.availableActions(model, onEdit: onSelectItem, isReadOnly: isReadonly);
    return withIcons(actions, modelActionIcons);
  }

  List<ModelAction> availablePopupActions(
      SurveyQuestionFormViewModel model) {
    final actions = surveyQuestionFormViewModels.availablePopupActions(model);
    return withIcons(actions, modelActionIcons);
  }

  List<ModelAction> availableInlineActions(
      SurveyQuestionFormViewModel model) {
    final actions = surveyQuestionFormViewModels.availableInlineActions(model);
    return withIcons(actions, modelActionIcons);
  }

  @override
  void onSelectItem(SurveyQuestionFormViewModel item) {
    // TODO: open sidesheet programmatically
    print("select item");
  }

  @override
  void onNewItem() {
    // TODO: open sidesheet programmatically
    print("new item");
  }

  // - IFormViewModelDelegate

  @override
  void onCancel(
      SurveyQuestionFormViewModel formViewModel, FormMode prevFormMode) {
    return; // no-op
  }

  @override
  void onSave(
      SurveyQuestionFormViewModel formViewModel, FormMode prevFormMode) {
    if (prevFormMode == FormMode.create) {
      // Save the managed viewmodel that was eagerly added in [provide]
      surveyQuestionFormViewModels.commit(formViewModel);
    } else if (prevFormMode == FormMode.edit) {
      // nothing to do here
    }
  }

  // - IProviderArgsResolver

  @override
  SurveyQuestionFormViewModel provide(SurveyQuestionFormRouteArgs args) {
    if (args.questionId.isNewId) {
      // Eagerly add the managed viewmodel in case it needs to be [provide]d
      // to a child controller
      final viewModel =
          SurveyQuestionFormViewModel(formData: null, delegate: this);
      surveyQuestionFormViewModels.stage(viewModel);
      return viewModel;
    }

    final viewModel = surveyQuestionFormViewModels
        .findWhere((vm) => vm.questionId == args.questionId);
    if (viewModel == null) {
      throw SurveyQuestionNotFoundException(); // TODO handle 404 not found
    }
    return viewModel;
  }

  // TODO: get rid of this after refactoring sidesheet to route (inject from router)

  SurveyQuestionFormRouteArgs buildNewFormRouteArgs() {
    return SurveyQuestionFormRouteArgs(
      studyId: study.id,
      measurementId: measurementId,
      questionId: Config.newModelId,
    );
  }

  SurveyQuestionFormRouteArgs buildFormRouteArgs(SurveyQuestionFormViewModel model) {
    final args = SurveyQuestionFormRouteArgs(
      studyId: study.id,
      measurementId: measurementId,
      questionId: model.questionId,
    );
    return args;
  }

  // ManagedFormViewModel

  @override
  MeasurementSurveyFormViewModel createDuplicate() {
    return MeasurementSurveyFormViewModel(
        study: study, delegate: delegate, formData: formData?.copy());
  }
}
