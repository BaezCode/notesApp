import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/helpers/dialogFolders.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MenuPopImages extends StatelessWidget {
  final List<String> image;
  final String title;
  final String cuerpo;
  const MenuPopImages(
      {Key? key,
      required this.image,
      required this.title,
      required this.cuerpo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black,
        size: 20,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          CustomDialogFolder.namePdfImages(context, cuerpo, title, image);
        }
        if (selectedValue == 1) {
          List<String> path = [];
          var rng = Random();

          for (var element in image) {
            final decodeData = base64Decode(element);
            final tempDir = await getTemporaryDirectory();
            File file = await File(
                    '${tempDir.path}/${rng.nextInt(10001100).toString()}.jpg')
                .create();
            file.writeAsBytesSync(decodeData);
            path.add(file.path);
          }
          Share.shareFiles(path);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 20,
                color: Colors.black,
              ),
              Text(' ${location.sharePdf}')
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
              Text(' ${location.shareImages}')
            ],
          ),
          value: 1,
        ),
      ],
    );
  }
}
