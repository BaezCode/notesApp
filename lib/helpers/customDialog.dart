import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/models/task_models.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class CustomWidgets {
  CustomWidgets._();

  static buildDialog(
    BuildContext context,
    FolderModel data,
  ) {
    final blocNotes = BlocProvider.of<NotesBloc>(context);
    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              title: Text(location.menuOptions),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    editName(context, data);
                  },
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  title: Text(location.editarNombre),
                ),
                ListTile(
                  onTap: () {
                    blocNotes.borrarScanPorId(data.id, data.tipo);
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.black,
                  ),
                  title: Text(
                    location.delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    location.exit,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ));
  }

  static modalMenu(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String contenido = '';
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    actions: [
                      if (state.dateFormat.isEmpty)
                        SizedBox(
                          width: size.width * 0.33,
                          height: size.height * 0.050,
                        ),
                      if (state.dateFormat.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            taskBloc.add(SetFormat(''));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20)),
                            width: size.width * 0.33,
                            height: size.height * 0.050,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.dateFormat.characters
                                      .take(9)
                                      .toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.cancel_outlined,
                                  size: 17,
                                )
                              ],
                            ),
                          ),
                        ),
                      IconButton(
                          onPressed: () {
                            CustomWidgets.buildModalMenu(context, null, null);
                          },
                          icon: const Icon(Icons.alarm)),
                      TextButton(
                          onPressed: contenido.isEmpty
                              ? null
                              : () async {
                                  taskBloc.newTask(contenido, state.dateFormat,
                                      state.repeat, state.details);
                                  Navigator.pop(context);
                                },
                          child: Text(
                            location.save,
                          ))
                    ],
                    content: SizedBox(
                      height: size.height * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          initialValue: contenido,
                          key: const ValueKey('contenido'),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: location.hintNotes,
                              hintStyle: const TextStyle(color: Colors.black)),
                          maxLines: null,
                          onChanged: (value) => setState(() {
                            contenido = value;
                          }),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return location.contentEmpy;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  static buildModalMenu(
      BuildContext context, TaskModel? task, FolderModel? folder) {
    final blocTask = BlocProvider.of<TaskBloc>(context);
    final size = MediaQuery.of(context).size;
    DateTime selectedDate = DateTime.now();
    final firstDate = DateTime.now().subtract(const Duration(days: 0));
    final lastDate = DateTime(2100);
    TimeOfDay time = TimeOfDay.now();
    final location = AppLocalizations.of(context)!;

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bx) {
          return SingleChildScrollView(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                return SizedBox(
                    height: size.height * 0.75,
                    child: ListView(
                      children: [
                        CalendarDatePicker(
                            initialDate: selectedDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            onDateChanged: (newDate) {
                              blocTask.add(SetAlarm(
                                newDate.year,
                                newDate.month,
                                newDate.day,
                              ));
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          onTap: () async {
                            TimeOfDay? newTime = await showTimePicker(
                                context: context, initialTime: time);
                            if (newTime == null) return;

                            blocTask
                                .add(SetHours(newTime.minute, newTime.hour));
                          },
                          trailing: const Icon(Icons.arrow_back_outlined),
                          title: Text(
                            location.setHours,
                          ),
                          leading: const Icon(
                            Icons.access_alarms_outlined,
                            size: 25,
                          ),
                          subtitle: Text(
                              '${state.hour}: ${state.minutes.toString().padLeft(2, '0')}'),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                                onPressed: () {
                                  blocTask.add(SetFormat(''));
                                  Navigator.pop(context);
                                },
                                child: Text(location.cancel)),
                            MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.black,
                                onPressed: () {
                                  String locale =
                                      Localizations.localeOf(context)
                                          .languageCode;

                                  final now = DateTime(state.years, state.month,
                                      state.days, state.hour, state.minutes);
                                  final day = DateFormat.EEEE(locale)
                                      .format(now)
                                      .characters
                                      .take(6);
                                  final fecha =
                                      DateFormat.MMMMd(locale).format(now);
                                  switch (now.compareTo(DateTime.now())) {
                                    case -1:
                                      Fluttertoast.showToast(
                                          msg: location.setCorrectTime);
                                      break;
                                    case 0:
                                      Fluttertoast.showToast(
                                          msg: location.setCorrectTime);
                                      break;
                                    case 1:
                                      if (task == null) {
                                        blocTask.add(SetFormat(
                                            '$day.$fecha:  ${state.hour} : ${state.minutes}'));
                                        Navigator.pop(context);
                                      } else {
                                        blocTask.updateHourSet(
                                            task,
                                            '$day.$fecha:  ${state.hour} : ${state.minutes}',
                                            state.repeat);
                                        Navigator.of(context)
                                          ..pop()
                                          ..pop();
                                        Fluttertoast.showToast(
                                            msg: location.completedTask);
                                      }

                                      break;
                                    default:
                                  }
                                },
                                child: Text(
                                  location.confirm,
                                  style: const TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ],
                    ));
              },
            ),
          );
        });
  }

  static editName(BuildContext context, FolderModel data) {
    final location = AppLocalizations.of(context)!;
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    String content = '';

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    notesBloc.updateScan(data, content, data.cuerpo!, data.tipo,
                        data.imagen, data.time);
                    Fluttertoast.showToast(msg: 'Name Updated');
                    Navigator.pop(context);
                  },
                  child: Text(location.confirm))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: data.nombre,
              style: const TextStyle(color: Colors.black),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: location.addDetaills,
                  hintStyle: const TextStyle(color: Colors.black)),
              maxLines: null,
              onChanged: (value) => content = value,
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
