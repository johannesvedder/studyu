import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:studyu_designer_v2/common_views/layout_two_column.dart';
import 'package:studyu_designer_v2/common_views/studyu_logo.dart';
import 'package:studyu_designer_v2/common_views/text_hyperlink.dart';
import 'package:studyu_designer_v2/common_views/text_paragraph.dart';
import 'package:studyu_designer_v2/common_views/utils.dart';
import 'package:studyu_designer_v2/features/auth/auth_form_controller.dart';
import 'package:studyu_designer_v2/features/auth/studyu_jtbd.dart';
import 'package:studyu_designer_v2/localization/language_picker.dart';
import 'package:studyu_designer_v2/localization/locale_providers.dart';
import 'package:studyu_designer_v2/repositories/app_repository.dart';
import 'package:studyu_designer_v2/routing/router_config.dart';
import 'package:studyu_designer_v2/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScaffold extends ConsumerStatefulWidget {
  const AuthScaffold({
    required this.body,
    required this.formKey,
    this.leftContentMinWidth = 424.0,
    this.leftPanelMinWidth = 500.0,
    this.leftPanelPadding = const EdgeInsets.fromLTRB(88.0, 54.0, 88.0, 40.0),
    Key? key,
  }) : super(key: key);

  final Widget body;
  final AuthFormKey formKey;

  final double leftContentMinWidth;
  final double leftPanelMinWidth;

  final EdgeInsets leftPanelPadding;

  @override
  ConsumerState<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends ConsumerState<AuthScaffold> {
  AuthFormKey get formKey => widget.formKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ref.watch(authFormControllerProvider(formKey).notifier);
    print("AuthScaffold.build");

    return Scaffold(
      key: RouterKeys.authKey,
      backgroundColor: Colors.white,
      appBar: null,
      body: TwoColumnLayout(
        flexLeft: 6,
        flexRight: 7,
        leftWidget: ReactiveFormConfig(
          validationMessages: AuthFormController.authValidationMessages,
          child: ReactiveForm(
            formGroup: controller.form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 88.0),
                  child: const StudyULogo(),
                ),
                const SizedBox(height: 48.0),
                Flexible(
                  child: Padding(
                    // adjust for whitespace in logo
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      constraints:
                      BoxConstraints(maxWidth: widget.leftContentMinWidth - 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            formKey.title,
                            style: theme.textTheme.headline3!,
                          ),
                          const SizedBox(height: 12.0),
                          (formKey.description != null) ?
                          TextParagraph(
                            text: formKey.description,
                            style: ThemeConfig.bodyTextMuted(theme),
                          ) : const SizedBox.shrink(),
                          const SizedBox(height: 40.0),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: widget.body,
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  // adjust for whitespace in logo
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                    constraints:
                    BoxConstraints(maxWidth: widget.leftPanelMinWidth - 12 * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableText(
                          "© HPI Digital Health Center 2022",
                          style: ThemeConfig.bodyTextBackground(theme),
                        ),
                        Row(
                          children: [
                            LanguagePicker(
                              languagePickerType: LanguagePickerType.icon,
                              iconColor: ThemeConfig.bodyTextBackground(theme).color!,
                              offset: const Offset(0, -60),
                            ),
                            const SizedBox(width: 12.0),
                            Hyperlink(
                              text: "Imprint",
                              onClick: () => _onClickImprint(),
                              linkColor:
                              ThemeConfig.bodyTextBackground(theme).color!,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        rightWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: Center(
                child: StudyUJobsToBeDone(),
              ),
            ),
          ],
        ),
        headerWidget: null,
        backgroundColorLeft: ThemeConfig.bodyBackgroundColor(theme),
        backgroundColorRight: theme.colorScheme.primary,
        constraintsLeft: BoxConstraints(minWidth: widget.leftPanelMinWidth),
        stretchHeight: true,
        paddingLeft: widget.leftPanelPadding,
      ),
    );
  }

  _onClickImprint() {
    final appConfig = ref.watch(appConfigProvider);
    final locale = ref.watch(localeProvider);

    launchUrl(appConfig.maybeWhen(
      data: (value) => Uri.parse(value.imprint[locale.languageCode] ?? ""),
      orElse: () => Uri.parse(''),
    ));
  }
}