import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/subtask/subtask_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/helpers/dialog.dart';
import 'package:notes/helpers/navegar_fadein.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/pages/task_options.dart';
import 'package:notes/widgets/charger_icons.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, TaskState state) {
        return state.task.isEmpty
            ? ChargerIcons(
                images: 'images/checklist.json',
                text: location.taskmoment,
              )
            : ListView.builder(
                itemCount: state.task.length,
                itemBuilder: (ctx, i) => _crearBody(state.task[i], context));
      },
    );
  }

  Widget _crearBody(TaskModel task, BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final AwesomeNotifications flutterLocalNotificationsPlugin =
        AwesomeNotifications();
    final location = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.50, color: Colors.grey)),
      ),
      child: FadeIn(
        child: ListTile(
            trailing: task.hoursSet!.isEmpty
                ? null
                : Icon(
                    task.repeat == 1 ? Icons.repeat : Icons.alarm,
                    size: 20,
                  ),
            subtitle: task.hoursSet!.isEmpty
                ? null
                : Text(
                    task.hoursSet!,
                    style: TextStyle(color: Colors.blue[700], fontSize: 12),
                  ),
            onLongPress: () async {
              final action = await Dialogs.yesAbortDialog(
                  context, location.delete, location.deleteTask);
              if (action == DialogAction.yes) {
                await flutterLocalNotificationsPlugin.cancel(task.id);
                taskBloc.borrarScanPorId(task.id, 0);
              } else {}
            },
            onTap: () {
              BlocProvider.of<SubtaskBloc>(context).add(LoadTask(
                  task.id,
                  task.task,
                  task.completed,
                  task.details,
                  task.hoursSet,
                  task.subtask == null ? [] : jsonDecode(task.subtask!)));
              Navigator.push(
                  context,
                  navegarFadeIn(
                      context,
                      TaskOptions(
                        task: task,
                      )));
            },
            title: Text(
              task.task,
            ),
            leading: GestureDetector(
              onTap: () async {
                taskBloc.updateTask(
                  task,
                  1,
                );
                await flutterLocalNotificationsPlugin.cancel(task.id);
              },
              child: Icon(
                Icons.circle_outlined,
                color: Colors.blue[700],
              ),
            )),
      ),
    );
  }
}
