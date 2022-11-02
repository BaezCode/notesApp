import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:pdf_text/pdf_text.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final location = AppLocalizations.of(context)!;
    PDFDoc? _pdfDoc;

    return Padding(
      padding: const EdgeInsets.only(top: 35, bottom: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Drawer(child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          location.options,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.cancel,
                              size: 20,
                            ))
                      ],
                    )),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.all_inbox_rounded,
                            color: Colors.black,
                          ),
                          Text(
                            '   ${location.showAll}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 0,
                      groupValue: state.groupValue,
                      onChanged: (value) {
                        notesBloc.add(GroupValue(value!));
                        Navigator.pop(context);
                      }),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.text_fields_rounded,
                            color: Colors.black,
                          ),
                          Text(
                            '   ${location.showNotes}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 1,
                      groupValue: state.groupValue,
                      onChanged: (value) {
                        notesBloc.add(GroupValue(value!));
                        Navigator.pop(context);
                      }),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                          Text(
                            '   ${location.showImages}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 2,
                      groupValue: state.groupValue,
                      onChanged: (value) {
                        notesBloc.add(GroupValue(value!));
                        Navigator.pop(context);
                      }),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.audio_file,
                            color: Colors.black,
                          ),
                          Text(
                            '    ${location.audiFile}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 3,
                      groupValue: state.groupValue,
                      onChanged: (value) {
                        notesBloc.add(GroupValue(value!));
                        Navigator.pop(context);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    location.order,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.arrow_circle_down,
                            color: Colors.black,
                          ),
                          Text(
                            '   ${location.orderAlpha}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 1,
                      groupValue: state.orderValue,
                      onChanged: (value) {
                        notesBloc.add(OrderValue(value!));
                        Navigator.pop(context);
                      }),
                ),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.black),
                  child: RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.arrow_circle_up_outlined,
                            color: Colors.black,
                          ),
                          Text(
                            '   ${location.orderAlphaRe}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                      value: 2,
                      groupValue: state.orderValue,
                      onChanged: (value) {
                        notesBloc.add(OrderValue(value!));
                        Navigator.pop(context);
                      }),
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
