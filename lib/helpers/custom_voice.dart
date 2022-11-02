import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/bloc/audiobloc/audio_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/helpers/navegar_fadein.dart';
import 'package:notes/pages/audio_page.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class CustomVoice {
  CustomVoice._();

  static audioPop(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioBloc = BlocProvider.of<AudioBloc>(context);

    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<AudioBloc, AudioState>(
            builder: (context, state) {
              return Container(
                color: Colors.white,
                height: state.path.isEmpty
                    ? size.height * 0.17
                    : size.height * 0.20,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${state.minutes}:${state.seconds}',
                            style: const TextStyle(fontSize: 25),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FlipInY(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: IconButton(
                                onPressed: () async {
                                  await audioBloc.stopTimer();

                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  size: 22,
                                )),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (state.stop) {
                                  await audioBloc.resumeTimer();
                                } else {
                                  await audioBloc.pauseTimer();
                                }
                              },
                              icon: Icon(
                                state.stop
                                    ? CupertinoIcons.play_circle
                                    : CupertinoIcons.pause_circle,
                                size: 30,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                                onPressed: () async {
                                  await audioBloc.confirmAudio();
                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      navegarFadeIn(
                                          context,
                                          const AudioPage(
                                            data: null,
                                          )));
                                },
                                icon: const Icon(
                                  CupertinoIcons.checkmark_circle_fill,
                                  size: 25,
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  static audioName(BuildContext context, String path, String time) {
    final location = AppLocalizations.of(context)!;
    final notesbloc = BlocProvider.of<NotesBloc>(context);
    String contenido = 'AudioFile';

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            title: Text(
              location.audioFileName,
              style: const TextStyle(fontSize: 15),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () {
                    notesbloc.nuevoFolder(0, contenido, 3, path, '', time);
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    Fluttertoast.showToast(msg: location.audioFilesaved);
                  },
                  child: Text(location.confirm))
            ],
            content: TextFormField(
              style: const TextStyle(color: Colors.black),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              initialValue: contenido,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: location.namePdf,
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
