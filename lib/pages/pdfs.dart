import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/helpers/dialog.dart';
import 'package:notes/models/pdfs_model.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:notes/widgets/charger_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class PdfsPage extends StatelessWidget {
  const PdfsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfsBloc = BlocProvider.of<PdfsBloc>(context);
    final location = AppLocalizations.of(context)!;

    return BlocBuilder<PdfsBloc, PdfsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                if (state.pdfs.isNotEmpty)
                  IconButton(
                      onPressed: () async {
                        final action = await Dialogs.yesAbortDialog(
                            context, location.delete, location.deletepdf);
                        if (action == DialogAction.yes) {
                          for (var element in state.pdfs) {
                            pdfsBloc.borrarPdf(element.id);
                          }
                        } else {}
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ))
              ],
              title: const Text(
                'PDF Generates',
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
              leading: BotonTrasero(ontap: () => Navigator.pop(context)),
              backgroundColor: Colors.white,
            ),
            body: state.pdfs.isEmpty
                ? const ChargerIcons(images: 'images/empty.json', text: '')
                : ListView.builder(
                    itemCount: state.pdfs.length,
                    itemBuilder: (ctx, i) => _crearBody(state.pdfs[i], context),
                  ));
      },
    );
  }

  Widget _crearBody(PdfsModel pdfs, BuildContext context) {
    final pdfsBloc = BlocProvider.of<PdfsBloc>(context);

    return ListTile(
      onLongPress: () async {
        final action = await Dialogs.yesAbortDialog(
            context, 'Delete Pdf', 'Do you want to delete ${pdfs.nombre}?');
        if (action == DialogAction.yes) {
          pdfsBloc.borrarPdf(pdfs.id);
        } else {}
      },
      onTap: () async {
        await OpenFile.open(pdfs.path);
      },
      leading: const Icon(Icons.picture_as_pdf_sharp),
      title: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              style: TextStyle(color: Colors.black), text: pdfs.nombre)),
      trailing: Text(pdfs.fecha),
    );
  }
}
