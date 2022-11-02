import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class PassWordPage extends StatefulWidget {
  const PassWordPage({Key? key}) : super(key: key);

  @override
  State<PassWordPage> createState() => _PassWordPageState();
}

class _PassWordPageState extends State<PassWordPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      showCupertinoDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => _showDialogPin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _showDialogPin() {
    final size = MediaQuery.of(context).size;
    final _prefs = PreferenciasUsuario();
    final blocPdf = BlocProvider.of<PdfsBloc>(context);
    final location = AppLocalizations.of(context)!;

    String contenido = '';

    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: [
          TextButton(
              child: Text(
                location.confirm,
              ),
              onPressed: () {
                if (_prefs.pinString == contenido) {
                  Navigator.pop(context);
                  blocPdf.add(SetPasswordData(contenido));
                } else {
                  Fluttertoast.showToast(msg: location.incorrectPas);
                }
              }),
          TextButton(
              child: Text(
                location.cancel,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                SystemNavigator.pop();
              }),
        ],
        title: Text(
          location.insertPass,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: size.width * 0.6,
          child: CupertinoTextField(
            obscureText: true,
            autofocus: true,
            style: const TextStyle(color: Colors.black),
            key: const ValueKey('nombreGrupo'),
            onChanged: (value) => contenido = value,
          ),
        ));
  }
}
