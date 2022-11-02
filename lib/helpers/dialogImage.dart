import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidgetsImage {
  CustomWidgetsImage._();

  static buildShowImage(BuildContext context, String data) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (bc) {
          return AlertDialog(
            content: FadeInImage(
              fadeInDuration: const Duration(milliseconds: 200),
              fit: BoxFit.cover,
              placeholder: const AssetImage('images/jar-loading.gif'),
              image: MemoryImage(base64Decode(data)),
            ),
          );
        });
  }
}
