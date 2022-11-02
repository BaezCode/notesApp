import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/helpers/dialog.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class TaskCompleted extends StatelessWidget {
  const TaskCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocTask = BlocProvider.of<TaskBloc>(context);
    final location = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        blocTask.cargarScanPorTipo(0);
        return true;
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              leading: BotonTrasero(
                ontap: () {
                  blocTask.cargarScanPorTipo(0);
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
              title: Text(
                location.completedTask,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              actions: [
                if (state.task.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        for (var element in state.task) {
                          blocTask.borrarScanPorId(
                              element.id, element.completed);
                        }
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.black,
                      ))
              ],
            ),
            body: state.task.isEmpty
                ? _createNoData(context)
                : ListView.builder(
                    itemCount: state.task.length,
                    itemBuilder: (ctx, i) => _crearBody(
                      state.task[i],
                      context,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _crearBody(
    TaskModel task,
    BuildContext context,
  ) {
    final blocTask = BlocProvider.of<TaskBloc>(context);
    final location = AppLocalizations.of(context)!;

    return ListTile(
      onLongPress: () async {
        final action = await Dialogs.yesAbortDialog(
            context, location.delete, location.deleteTask);
        if (action == DialogAction.yes) {
          blocTask.borrarScanPorId(task.id, task.completed);
        } else {}
      },
      leading: const Icon(
        Icons.check,
        color: Colors.black,
      ),
      title: Text(
        task.task,
        style: const TextStyle(decoration: TextDecoration.lineThrough),
      ),
    );
  }

  Widget _createNoData(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('images/completed.json', height: size.height * 0.20),
        ],
      ),
    );
  }
}
