import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notes/bloc/audiobloc/audio_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/helpers/customDialog.dart';
import 'package:notes/helpers/custom_voice.dart';
import 'package:notes/helpers/navegar_fadein.dart';
import 'package:notes/pages/notes_page.dart';
import 'package:notes/pages/task_completed.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class Floatingnotes extends StatelessWidget {
  final int index;
  final int tipo;
  const Floatingnotes({Key? key, required this.index, required this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _selectetFloatings(context);
  }

  Widget _selectetFloatings(BuildContext context) {
    switch (index) {
      case 0:
        return _floatingfolders(context);
      case 1:
        return _floatingTask(context);
      default:
        return _floatingfolders(context);
    }
  }

  SpeedDial _floatingfolders(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final audioBloc = BlocProvider.of<AudioBloc>(context);

    return SpeedDial(
      backgroundColor: Colors.black,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.text_fields_outlined),
            label: location.notes,
            onTap: () => Navigator.push(
                context,
                navegarFadeIn(
                    context,
                    NotesPage(
                      tipo: tipo,
                      folderModel: null,
                    )))),
        SpeedDialChild(
            child: const Icon(Icons.image),
            label: location.images,
            onTap: () => Navigator.pushNamed(context, 'imagePage')),
        SpeedDialChild(
            child: const Icon(Icons.mic),
            label: location.voz,
            onTap: () {
              audioBloc.start();
              CustomVoice.audioPop(context);
            }),
      ],
    );
  }

  SpeedDial _floatingTask(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final date = DateTime.now();
    return SpeedDial(
      backgroundColor: Colors.black,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.add_task_rounded),
            label: location.newTask,
            onTap: () {
              taskBloc.add(SetAlarm(
                date.year,
                date.month,
                date.day,
              ));
              CustomWidgets.modalMenu(context);
            }),
        SpeedDialChild(
            child: const Icon(Icons.task_alt_rounded),
            label: location.completedTask,
            onTap: () {
              taskBloc.cargarScanPorTipo(1);
              Navigator.push(
                  context, navegarFadeIn(context, const TaskCompleted()));
            }),
      ],
    );
  }
}
