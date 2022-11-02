import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/bloc/subtask/subtask_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/helpers/customDialog.dart';
import 'package:notes/helpers/detailsDialog.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class TaskOptions extends StatefulWidget {
  final TaskModel task;

  const TaskOptions({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskOptions> createState() => _TaskOptionsState();
}

class _TaskOptionsState extends State<TaskOptions> {
  String contenido = '';
  late TaskBloc taskBloc;
  late SubtaskBloc subtaskBloc;
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  final date = DateTime.now();

  @override
  void initState() {
    super.initState();
    taskBloc = BlocProvider.of<TaskBloc>(context);
    subtaskBloc = BlocProvider.of<SubtaskBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<SubtaskBloc, SubtaskState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: _crearBotonNav(state),
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            leading: BotonTrasero(ontap: () => Navigator.pop(context)),
            actions: [
              IconButton(
                  onPressed: () {
                    taskBloc.borrarScanPorId(state.id, state.completed);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                  ))
            ],
            title: Text(
              location.taskoptions,
              style: const TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    location.myTaks,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                ),
                _crearTexto(state),
                ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                  onTap: () => DetailsDialog.detailsDialog(context, state),
                  leading: const Icon(Icons.text_snippet_outlined),
                  title: Text(location.addDetaills),
                  subtitle: state.details == null
                      ? null
                      : Row(
                          children: [
                            const Icon(
                              Icons.circle_notifications_rounded,
                              size: 10,
                            ),
                            Text('  ${state.details}')
                          ],
                        ),
                ),
                ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                  onTap: () {
                    taskBloc.add(SetAlarm(
                      date.year,
                      date.month,
                      date.day,
                    ));
                    CustomWidgets.buildModalMenu(context, widget.task, null);
                  },
                  leading: const Icon(Icons.date_range_outlined),
                  title: Text(location.hoursdate),
                  subtitle: state.hoursSet!.isEmpty
                      ? null
                      : Text(
                          state.hoursSet!,
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                ),
                ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        DetailsDialog.dialogSubtask(context, state);
                      },
                      icon: const Icon(Icons.add)),
                  leading: const Icon(Icons.subdirectory_arrow_right_outlined),
                  title: const Text('Subtareas'),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.subtask.length,
                  itemBuilder: (ctx, i) {
                    final title = state.subtask[i];
                    return FadeIn(
                      child: ListTile(
                        title: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            IconButton(
                                onPressed: () {
                                  subtaskBloc.removeData(title, state);
                                  taskBloc.cargarScanPorTipo(state.completed);
                                },
                                icon: Icon(
                                  Icons.circle_outlined,
                                  color: Colors.blue[700],
                                )),
                            Text(title)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _crearTexto(SubtaskState state) {
    final size = MediaQuery.of(context).size;
    final location = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.70, color: Colors.grey))),
      height: size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.black,
          ),
          autofocus: false,
          keyboardType: TextInputType.multiline,
          initialValue: state.task,
          key: const ValueKey('contenido'),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: location.hintNotes,
              hintStyle: const TextStyle(color: Colors.black)),
          maxLines: null,
          onChanged: (value) {
            taskBloc.updateTaskDo(
              state,
              state.completed,
              value,
            );
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return location.contentEmpy;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _crearBotonNav(SubtaskState state) {
    final location = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(state.completed == 0
              ? Icons.task_alt_outlined
              : Icons.circle_outlined),
          TextButton(
              onPressed: () async {
                taskBloc.updateTask(
                  widget.task,
                  1,
                );
                await awesomeNotifications.cancel(state.id);
                Navigator.pop(context);
                Fluttertoast.showToast(msg: location.completedTask);
              },
              child: Text(
                state.completed == 0
                    ? location.markCompleted
                    : location.marknotCompleted,
              ))
        ],
      ),
    );
  }
}
