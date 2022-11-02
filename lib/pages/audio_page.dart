import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/audiobloc/audio_bloc.dart';
import 'package:notes/helpers/custom_voice.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AudioPage extends StatefulWidget {
  final FolderModel? data;
  const AudioPage({Key? key, required this.data}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();

  late AudioBloc audioBloc;
  @override
  void initState() {
    super.initState();
    audioBloc = BlocProvider.of<AudioBloc>(context);
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
    // Listen to audio Duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((data) {
      setState(() {
        position = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: widget.data == null
              ? FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    CustomVoice.audioName(
                        context, state.path, state.totalDuration);
                  })
              : null,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () async {
                    final decodeData = base64Decode(state.path);
                    final tempDir = await getTemporaryDirectory();
                    File file =
                        await File('${tempDir.path}/audio.mp3').create();
                    file.writeAsBytesSync(decodeData);
                    Share.shareFiles([(file.path)],
                        text: widget.data?.nombre == null
                            ? 'audio'
                            : widget.data!.nombre);
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ))
            ],
            title: Text(
              location.audiFile,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            leading: BotonTrasero(ontap: () => Navigator.pop(context)),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                trailing: isPlaying
                    ? Text(audioBloc.formatTime(duration - position))
                    : Text(state.totalDuration),
                leading: IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        final decodeData = base64Decode(state.path);
                        audioPlayer.playBytes(decodeData);
                      }
                    },
                    icon: Icon(
                      isPlaying
                          ? CupertinoIcons.pause_circle_fill
                          : CupertinoIcons.play_circle_fill,
                      size: 30,
                      color: Colors.black,
                    )),
                title: Slider(
                    thumbColor: Colors.black,
                    activeColor: Colors.grey[700],
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      // opdtional
                      await audioPlayer.resume();
                    }),
              ),
              const Divider(
                color: Colors.black,
              ),
              if (widget.data != null)
                ListTile(
                  title: Text(
                    '${location.creado}: ${widget.data!.fecha}',
                    style: const TextStyle(fontSize: 15),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
