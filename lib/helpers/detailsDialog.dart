import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/bloc/subtask/subtask_bloc.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:notes/bloc/task/task_bloc.dart';

class DetailsDialog {
  DetailsDialog._();

  static dialogSubtask(BuildContext context, SubtaskState task) {
    final location = AppLocalizations.of(context)!;
    String content = '';
    final subTaskBloc = BlocProvider.of<SubtaskBloc>(context);
    final taskbloc = BlocProvider.of<TaskBloc>(context);

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: content.isEmpty
                          ? null
                          : () {
                              subTaskBloc.addSubTask(content, task);
                              taskbloc.cargarScanPorTipo(task.completed);
                              Navigator.pop(context);
                            },
                      child: Text(location.confirm))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  key: const ValueKey('contenido'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: location.addDetaills,
                      hintStyle: const TextStyle(color: Colors.black)),
                  maxLines: null,
                  onChanged: (value) => setState(() {
                    content = value;
                  }),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return location.contentEmpy;
                    }
                    return null;
                  },
                ),
              );
            },
          );
        });
  }

  static detailsDialog(BuildContext context, SubtaskState state) {
    String contenido = '';
    final subtaskBloc = BlocProvider.of<SubtaskBloc>(context);
    final taskBloc = BlocProvider.of<TaskBloc>(context);

    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () {
                    subtaskBloc.updateTaskDetails(state, contenido);
                    taskBloc.cargarScanPorTipo(state.completed);
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: location.detailsUpdate);
                  },
                  child: Text(location.confirm)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    location.cancel,
                    style: const TextStyle(color: Colors.red),
                  )),
            ],
            content: TextFormField(
              style: const TextStyle(color: Colors.black),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              initialValue: state.details,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: location.addDetaills,
                  hintStyle: const TextStyle(color: Colors.black)),
              maxLines: null,
              onChanged: (value) => contenido = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return location.contentEmpy;
                }
                return null;
              },
            ),
          );
        });
  }
}
