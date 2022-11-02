import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:notes/widgets/menu_pop_share.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class NotesPage extends StatefulWidget {
  final int tipo;
  final FolderModel? folderModel;
  const NotesPage({
    Key? key,
    required this.tipo,
    this.folderModel,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.folderModel != null) {
      try {
        var myJSON = jsonDecode(widget.folderModel!.cuerpo!);
        _controller = QuillController(
            document: Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
      } catch (e) {
        return;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _getData(String data) async {
    _controller.document.insert(0, data);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            var json = jsonEncode(_controller.document.toDelta().toJson());
            if (state.updated) {
              notesBloc.updateScan(
                  widget.folderModel, state.titulo, json, widget.tipo, '', '');
              Navigator.pop(context);
            } else {
              notesBloc.nuevoFolder(widget.tipo, state.titulo, 1, json, '', '');
              Navigator.pop(context);
            }
            notesBloc.add(ClearNotes());
            return true;
          },
          child: Scaffold(
            appBar: appBar(state, context),
            body: Column(
              children: [
                Expanded(
                    child: QuillEditor(
                        controller: _controller,
                        focusNode: _focusNode,
                        scrollController: ScrollController(),
                        scrollable: true,
                        padding: const EdgeInsets.all(8),
                        autoFocus: false,
                        readOnly: false,
                        expands: false)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuillToolbar.basic(
                      fontSizeValues: const {
                        '8': '8',
                        '10': '10',
                        '12': '12',
                        '15': '15',
                        '18': '18',
                        '20': '20',
                        '22': '22'
                      },
                      showQuote: false,
                      showInlineCode: false,
                      toolbarIconSize: 20,
                      showCameraButton: false,
                      showCodeBlock: false,
                      showBoldButton: true,
                      showVideoButton: false,
                      showLink: false,
                      showImageButton: false,
                      controller: _controller),
                ),

                //          Expanded(child: _crearCuerpo(state, context)),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar appBar(
    NotesState state,
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final location = AppLocalizations.of(context)!;

    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: const Icon(
              CupertinoIcons.book,
              size: 23,
              color: Colors.black,
            )),
        Shared(
          onSubmit: _getData,
          cuerpo: _controller.document.toPlainText(),
          title: state.titulo,
          data: widget.folderModel,
        )
      ],
      title: GestureDetector(
        onTap: () {
          notesBloc.add(AppBarActive(true));
        },
        child: Text(
          state.titulo,
          style: TextStyle(color: Colors.grey[500], fontSize: 20),
        ),
      ),
      leading: state.appBarActive
          ? IconButton(onPressed: () {
              notesBloc.add(AppBarActive(false));
            }, icon: FlipInY(child: BotonTrasero(ontap: () {
              var json = jsonEncode(_controller.document.toDelta().toJson());

              if (state.updated) {
                notesBloc.updateScan(widget.folderModel, state.titulo, json,
                    widget.tipo, '', '');
                Navigator.pop(context);
              } else {
                notesBloc.nuevoFolder(
                    widget.tipo, state.titulo, 1, json, '', '');
                Navigator.pop(context);
              }
              notesBloc.add(ClearNotes());
            })))
          : FlipInX(child: BotonTrasero(
              ontap: () {
                var json = jsonEncode(_controller.document.toDelta().toJson());

                if (state.updated) {
                  notesBloc.updateScan(widget.folderModel, state.titulo, json,
                      widget.tipo, '', '');
                  Navigator.pop(context);
                } else {
                  notesBloc.nuevoFolder(
                      widget.tipo, state.titulo, 1, json, '', '');
                  Navigator.pop(context);
                }
                notesBloc.add(ClearNotes());
              },
            )),
      bottom: state.appBarActive
          ? PreferredSize(
              child: FadeIn(
                child: SizedBox(
                  height: 50,
                  width: size.width * 0.80,
                  child: TextFormField(
                    initialValue: state.titulo,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    textInputAction: TextInputAction.go,
                    autofocus: true,
                    key: const ValueKey('contenido'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: location.hintTitle,
                        hintStyle:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    onChanged: (value) {
                      var json =
                          jsonEncode(_controller.document.toDelta().toJson());

                      if (widget.folderModel == null) {
                        notesBloc.add(SetTitulo(value));
                      } else {
                        notesBloc.add(SetTitulo(value));
                        notesBloc.updateScan(widget.folderModel, value, json,
                            widget.tipo, 'image', '');
                      }
                    },
                    onFieldSubmitted: (vata) {
                      notesBloc.add(AppBarActive(false));
                    },
                  ),
                ),
              ),
              preferredSize: const Size.fromHeight(50))
          : null,
      backgroundColor: Colors.white,
    );
  }
}
