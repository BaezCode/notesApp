import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:notes/models/folder_model.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:share_plus/share_plus.dart';

class Shared extends StatelessWidget {
  final void Function(String) onSubmit;
  final String title;
  final String cuerpo;
  final FolderModel? data;

  const Shared(
      {Key? key,
      required this.title,
      required this.cuerpo,
      required this.data,
      required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final blocNotes = BlocProvider.of<NotesBloc>(context);
    PDFDoc? _pdfDoc;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black,
        size: 20,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 1) {
          Share.share(
            title,
            subject: cuerpo,
          );
        }
        if (selectedValue == 2) {
          blocNotes.borrarScanPorId(data!.id, data!.tipo);
          Navigator.pop(context);
        }
        if (selectedValue == 3) {
          var filePickerResult = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowMultiple: false,
              allowedExtensions: ['pdf']);
          if (filePickerResult != null) {
            _pdfDoc =
                await PDFDoc.fromPath(filePickerResult.files.single.path!);
            String text = await _pdfDoc!.text;
            onSubmit(text);
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Icon(
                FontAwesomeIcons.filePdf,
                size: 20,
                color: Colors.black,
              ),
              const Text(' Convert PDF to Text')
            ],
          ),
          value: 3,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.text_fields_outlined,
                size: 20,
                color: Colors.black,
              ),
              Text(' ${location.shareText}')
            ],
          ),
          value: 1,
        ),
        if (data != null)
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.black,
                ),
                Text(' ${location.delete}')
              ],
            ),
            value: 2,
          ),
      ],
    );
  }
}
