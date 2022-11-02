import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class PasswordDialogs {
  PasswordDialogs._();

  static passwordDialog(BuildContext context) {
    String contenido = '';
    final _formKey = GlobalKey<FormState>();
    final _prefs = PreferenciasUsuario();
    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    _prefs.pinString = contenido;
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: location.passwordCreated);
                  },
                  child: Text(location.confirm))
            ],
            content: Form(
              key: _formKey,
              child: TextFormField(
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                autofocus: true,
                initialValue: contenido,
                key: const ValueKey('contenido'),
                decoration: InputDecoration(
                    prefix: const Icon(
                      Icons.lock,
                      size: 15,
                    ),
                    border: InputBorder.none,
                    hintText: location.password,
                    hintStyle: const TextStyle(color: Colors.black)),
                onChanged: (value) => contenido = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return location.contentEmpy;
                  }
                  return null;
                },
              ),
            ),
          );
        });
  }

  static changePasswordDialog(BuildContext context) {
    String password = '';
    String nuevoPassword = '';

    final _formKey = GlobalKey<FormState>();
    final _prefs = PreferenciasUsuario();
    final size = MediaQuery.of(context).size;
    final location = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            title: const Text('Change Password'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    if (_prefs.pinString == password) {
                      _prefs.pinString = nuevoPassword;
                      Fluttertoast.showToast(msg: location.passwordCreated);
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: location.incorrectPas);
                    }
                  },
                  child: Text(location.confirm))
            ],
            content: Form(
                key: _formKey,
                child: SizedBox(
                  height: size.height * 0.20,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        autofocus: true,
                        key: const ValueKey('contenido'),
                        decoration: InputDecoration(
                            prefix: const Icon(
                              Icons.lock,
                              size: 15,
                            ),
                            hintText: location.password,
                            hintStyle: const TextStyle(color: Colors.black)),
                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return location.contentEmpy;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        autofocus: true,
                        key: const ValueKey('Cambiar'),
                        decoration: InputDecoration(
                            prefix: const Icon(
                              Icons.lock,
                              size: 15,
                            ),
                            hintText: location.newPassword,
                            hintStyle: const TextStyle(color: Colors.black)),
                        onChanged: (value) => nuevoPassword = value,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return location.contentEmpy;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
