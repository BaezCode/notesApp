import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/helpers/passwordDialogs.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class MenuPopPin extends StatefulWidget {
  const MenuPopPin({Key? key}) : super(key: key);

  @override
  State<MenuPopPin> createState() => _MenuPopPinState();
}

class _MenuPopPinState extends State<MenuPopPin> {
  final _prefs = PreferenciasUsuario();
  late PdfsBloc pdfsBloc;

  @override
  void initState() {
    super.initState();
    pdfsBloc = BlocProvider.of<PdfsBloc>(context);
    pdfsBloc.add(ActivePassword(_prefs.activepin));
  }

  @override
  Widget build(BuildContext context) {
    final blocPdf = BlocProvider.of<PdfsBloc>(context);
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
          PasswordDialogs.passwordDialog(context);
        }
        if (selectedValue == 1) {
          PasswordDialogs.changePasswordDialog(context);
        }
      },
      itemBuilder: (context) => [
        if (_prefs.pinString.isEmpty)
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(
                  Icons.lock,
                  size: 20,
                  color: Colors.black,
                ),
                Text('   ${location.passwordCreated}')
              ],
            ),
            value: 0,
          ),
        if (_prefs.pinString.isNotEmpty)
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(
                  Icons.password_rounded,
                  size: 20,
                  color: Colors.black,
                ),
                Text('  ${location.changePassword}')
              ],
            ),
            value: 1,
          ),
        if (_prefs.pinString.isNotEmpty)
          PopupMenuItem(
            child: BlocBuilder<PdfsBloc, PdfsState>(
              builder: (context, state) {
                return SwitchListTile(
                    title: Text(location.password),
                    value: state.password,
                    onChanged: (onChanged) {
                      blocPdf.add(ActivePassword(onChanged));
                      _prefs.activepin = onChanged;
                    });
              },
            ),
            value: 1,
          ),
      ],
    );
  }
}
