import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyu_designer_v2/features/auth/auth_controller.dart';
import 'package:studyu_designer_v2/features/auth/form_widgets.dart';
import 'package:studyu_designer_v2/flutter_flow/flutter_flow_theme.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  late TextEditingController emailController;
  late bool isFormValid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return _formWidget();
  }

  Widget _formWidget() {
    final authController = ref.watch(authControllerProvider.notifier);
    return Form(
      key: _formKey,
      onChanged: () => setState(() => isFormValid = _formKey.currentState!.validate()),
      child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text('Reset Password'.hardcoded, style: FlutterFlowTheme.of(context).title1,)),
            const SizedBox(height: 20),
            TextFormFieldWidget(emailController: emailController),
            const SizedBox(height: 20),
            buttonWidget(ref, isFormValid, 'Reset Password', () => authController.resetPasswordForEmail(
                emailController.text)),
          ]
      ),
    );
  }
}
