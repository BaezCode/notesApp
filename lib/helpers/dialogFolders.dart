import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/services/pdf_generate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class CustomDialogFolder {
  CustomDialogFolder._();

  static namePdfImages(
      BuildContext context, String cuerpo, String nombre, List<String> image) {
    final pdfsBloc = BlocProvider.of<PdfsBloc>(context);
    final location = AppLocalizations.of(context)!;

    String contenido = 'Notes';
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () async {
                    final Uint8List pdfw = await GeneratePdf.generatePdfImages(
                        nombre, cuerpo, context, image);
                    final dir = await getApplicationDocumentsDirectory();
                    final file = File('${dir.path}/$contenido.pdf');
                    await file.writeAsBytes(pdfw);
                    final url = file.path;
                    await pdfsBloc.nuevoFolder(nombre, url);
                    Share.shareFiles([url], text: 'Great picture');
                    Navigator.pop(context);
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
