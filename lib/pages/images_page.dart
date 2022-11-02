import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/ImageData/imagedata_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/helpers/dialogImage.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:notes/widgets/menu_pop_images.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:notes/widgets/menu_pop_select_image.dart';

class ImagesPage extends StatelessWidget {
  final FolderModel? data;
  const ImagesPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagedataBloc = BlocProvider.of<ImagedataBloc>(context);
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    final location = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ImagedataBloc, ImageDataState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            imagedataBloc.clear();
            return true;
          },
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                child: IconButton(
                    onPressed: () {
                      final String _encode = jsonEncode(state.images);

                      if (data == null) {
                        notesBloc.nuevoFolder(
                            1,
                            state.titulo,
                            2,
                            state.contenido,
                            _encode == "[]" ? '' : _encode,
                            '');
                        Navigator.pop(context);
                        imagedataBloc.clear();
                      } else {
                        notesBloc.updateScan(
                            data,
                            state.titulo,
                            state.contenido,
                            1,
                            _encode == "[]" ? '' : _encode,
                            '');
                        imagedataBloc.clear();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save)),
                onPressed: null),
            appBar: appBar(state, context, data ?? 'null'),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: state.titulo,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.go,
                      autofocus: false,
                      key: const ValueKey('contenido'),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: location.hintTitle,
                          hintStyle: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                      onChanged: (value) {
                        imagedataBloc.add(SetBarraTitle(value));
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  _crearTexto(state.contenido, context),
                  ListTile(
                    leading: const Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    title: Text('Images: ${state.images.length}'),
                    trailing: MenuPopSelectImage(index: state.images.length),
                  ),
                  if (state.images.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.17,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.images.length,
                          itemBuilder: (ctx, i) =>
                              _crearBody(context, state.images[i], state)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _crearBody(BuildContext context, String datos, ImageDataState state) {
    final size = MediaQuery.of(context).size;
    final imagedataBloc = BlocProvider.of<ImagedataBloc>(context);

    return SizedBox(
      height: 50,
      width: size.width * 0.30,
      child: Card(
          child: GestureDetector(
        onTap: () => CustomWidgetsImage.buildShowImage(context, datos),
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image(
                    fit: BoxFit.cover,
                    image: MemoryImage(base64Decode(datos)))),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  state.images.removeWhere((item) => item == datos);
                  imagedataBloc.add(SetImage(state.images));
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 9,
                  child: Icon(
                    Icons.cancel_outlined,
                    size: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  AppBar appBar(ImageDataState state, BuildContext context, data) {
    final imagedataBloc = BlocProvider.of<ImagedataBloc>(context);
    final blocNotes = BlocProvider.of<NotesBloc>(context);

    return AppBar(
      actions: [
        if (data != 'null')
          IconButton(
              onPressed: () {
                blocNotes.borrarScanPorId(data.id, data.tipo);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              )),
        if (state.images.isNotEmpty)
          MenuPopImages(
            cuerpo: state.contenido,
            title: state.titulo,
            image: state.images,
          ),
      ],
      title: Text(
        'Image Archive',
        style: TextStyle(color: Colors.grey[500], fontSize: 20),
      ),
      leading: BotonTrasero(
        ontap: () {
          imagedataBloc.clear();
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      elevation: 0.5,
    );
  }

  Widget _crearTexto(String contenido, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageDatabloc = BlocProvider.of<ImagedataBloc>(context);
    final location = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.70, color: Colors.grey))),
      height: size.height * 0.30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          initialValue: contenido,
          style: const TextStyle(
            color: Colors.black,
          ),
          autofocus: false,
          keyboardType: TextInputType.multiline,
          key: const ValueKey('contenido'),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: location.hintNotes,
              hintStyle: const TextStyle(color: Colors.black)),
          maxLines: null,
          onChanged: (value) => {imageDatabloc.add(SetContenido(value))},
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return location.contentEmpy;
            }
            return null;
          },
        ),
      ),
    );
  }
}
