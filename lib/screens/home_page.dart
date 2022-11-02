import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/ImageData/imagedata_bloc.dart';
import 'package:notes/bloc/audiobloc/audio_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/helpers/customDialog.dart';
import 'package:notes/helpers/navegar_fadein.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/pages/audio_page.dart';
import 'package:notes/pages/images_page.dart';
import 'package:notes/pages/notes_page.dart';
import 'package:notes/widgets/charger_icons.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return state.archives.isEmpty
            ? ChargerIcons(
                images: 'images/lottie.json',
                text: location.todook,
              )
            : ListView.builder(
                itemCount: state.archives.length,
                itemBuilder: (ctx, i) => state.orderValue <= 1
                    ? FadeIn(child: _crearBody(state.archives[i], context))
                    : FadeIn(
                        child: _crearBody(
                            state.archives[state.archives.length - 1 - i],
                            context)));
      },
    );
  }

  Widget _crearBody(FolderModel data, BuildContext context) {
    final imagedataBloc = BlocProvider.of<ImagedataBloc>(context);
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final audiBloc = BlocProvider.of<AudioBloc>(context);

    return ListTile(
      trailing: Text(
        data.fecha,
        style: const TextStyle(fontSize: 12),
      ),
      onLongPress: () => CustomWidgets.buildDialog(
        context,
        data,
      ),
      title: Text(data.nombre),
      leading: Icon(
        _crearArchivos(data, context),
        color: Colors.black,
      ),
      onTap: () {
        switch (data.clase) {
          case 2:
            final List<dynamic> decodeData =
                data.imagen!.isEmpty ? [] : jsonDecode(data.imagen!);
            imagedataBloc.loadImages(data.cuerpo!, data.nombre, decodeData);
            Navigator.push(
                context,
                navegarFadeIn(
                    context,
                    ImagesPage(
                      data: data,
                    )));
            break;
          case 1:
            notesBloc.add(ChargeData(data.nombre, true));
            Navigator.push(
                context,
                navegarFadeIn(
                    context,
                    NotesPage(
                      tipo: 1,
                      folderModel: data,
                    )));
            break;
          case 3:
            audiBloc.add(ChargerAudio(data.cuerpo!, data.time!));
            Navigator.push(
                context,
                navegarFadeIn(
                    context,
                    AudioPage(
                      data: data,
                    )));
            break;
          default:
        }
      },
    );
  }

  IconData _crearArchivos(FolderModel data, BuildContext context) {
    switch (data.clase) {
      case 1:
        return Icons.text_fields_rounded;
      case 2:
        return Icons.image;
      case 3:
        return Icons.audio_file;

      default:
        return Icons.image;
    }
  }
}
