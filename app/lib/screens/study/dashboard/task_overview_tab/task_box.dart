import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyu_app/routes.dart';
import 'package:studyu_core/core.dart';

import '../../../../models/app_state.dart';
import '../../../../theme.dart';
import '../../../../widgets/round_checkbox.dart';
import '../../tasks/task_screen.dart';

class TaskBox extends StatefulWidget {
  final TaskInstance taskInstance;
  final Icon icon;
  final Function() onCompleted;

  const TaskBox({
    Key key,
    @required this.taskInstance,
    @required this.icon,
    @required this.onCompleted,
  }) : super(key: key);

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  Future<void> _navigateToTaskScreen() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => TaskScreen(taskInstance: widget.taskInstance)),
    );
    widget.onCompleted();
    // Rebuild widget
    setState(() {});
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, Routes.loading, (_) => false);

    // todo only show loading screen if new phase has started to show updated dashboard
    // i.e. it is first day of a new phase
    // otherwise just reschedule notifications
    // redirect to loading screen also happens after notification at notifications.dart:202

    //context.read<AppState>().activeSubject.progress
    //context.read<AppState>().selectedStudy.schedule.
    /*if (StudyNotifications.validator.wasNotificationActionHandled &&
        !StudyNotifications.validator.wasNotificationActionCompleted) {
      StudyNotifications.validator.wasNotificationActionCompleted = true;
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, Routes.loading, (_) => false);
    } else {
      if (mounted) scheduleNotifications(context);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final completed = context.watch<AppState>().activeSubject
        .completedTaskInstanceForDay(widget.taskInstance.task.id, widget.taskInstance.completionPeriod, DateTime.now());
    final isPreview = context.read<AppState>().isPreview;
    final isInsidePeriod = widget.taskInstance.completionPeriod.contains(StudyUTimeOfDay.now());
    final isTaskOpen = !completed && isInsidePeriod || isPreview || kDebugMode;
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: (isTaskOpen) ? _navigateToTaskScreen : () {},
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: widget.icon,
                title: Text(widget.taskInstance.task.title ?? ''),
                onTap: isTaskOpen ? _navigateToTaskScreen : () {},
              ),
            ),
            if (isInsidePeriod || isPreview || completed)
              RoundCheckbox(
                value: completed, //_isCompleted,
                onChanged: (value) => isTaskOpen ? _navigateToTaskScreen() : () {},
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Icon(Icons.lock, color: theme.colorScheme.secondary),
              )
          ],
        ),
      ),
    );
  }
}
