import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class DialogSub {
  DialogSub._();

  static subTaskDialog(BuildContext context) {
    String contenido = '';

    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(onPressed: () {}, child: Text(location.confirm)),
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
                  hintText: location.addDetaills,
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
