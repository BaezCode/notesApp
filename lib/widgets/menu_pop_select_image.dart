import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:notes/bloc/ImageData/imagedata_bloc.dart';

class MenuPopSelectImage extends StatefulWidget {
  final int index;

  const MenuPopSelectImage({Key? key, required this.index}) : super(key: key);

  @override
  State<MenuPopSelectImage> createState() => _MenuPopSelectImageState();
}

class _MenuPopSelectImageState extends State<MenuPopSelectImage> {
  int _number = 0;

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final iamgedataBloc = BlocProvider.of<ImagedataBloc>(context);

    return PopupMenuButton(
      icon: const Icon(
        CupertinoIcons.add_circled_solid,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          _seleccionarFoto();
        }
        if (selectedValue == 1) {
          _seleccionargaleria();
        }
        if (selectedValue == 2) {
          iamgedataBloc.clear();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: Colors.black,
              ),
              Text(' ${location.cameradat}')
            ],
          ),
          value: 0,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.image,
                size: 20,
                color: Colors.black,
              ),
              Text(' ${location.gallery}')
            ],
          ),
          value: 1,
        ),
        if (widget.index > 0)
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(
                  Icons.clear,
                  size: 20,
                  color: Colors.black,
                ),
                Text(' ${location.clear}')
              ],
            ),
            value: 2,
          ),
      ],
    );
  }

  _seleccionarFoto() {
    if (widget.index >= 3) {
      Fluttertoast.showToast(msg: 'Max number of Image is 3');
    } else {
      _procesarImagen(ImageSource.camera, context);
    }
  }

  _seleccionargaleria() async {
    final imageBloc = BlocProvider.of<ImagedataBloc>(context);
    //int number = widget.index.remainder(5.remainder(3));
    _number = widget.index;

    List<Media>? res = await ImagesPicker.pick(
      maxSize: 500,
      quality: 0.6,
      language: Language.System,
      count: 3 - _number,
      pickType: PickType.image,
    );
    if (res == null) {
    } else {
      for (var element in res) {
        File file = File(element.path);

        String img64 = base64Encode(file.readAsBytesSync());
        await imageBloc.nuevoFolder(img64);
      }
    }
  }

  void _procesarImagen(ImageSource origen, BuildContext context) async {
    File pickedImage;
    final imageBloc = BlocProvider.of<ImagedataBloc>(context);

    try {
      final picker = ImagePicker();
      final foto =
          await picker.pickImage(maxHeight: 950, maxWidth: 950, source: origen);

      if (foto == null) {
      } else {
        pickedImage = File(foto.path);
        String img64 = base64Encode(pickedImage.readAsBytesSync());
        await imageBloc.nuevoFolder(img64);
      }
      // ignore: empty_catches
    } on NoSuchMethodError {}
  }
}
