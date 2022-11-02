import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/bloc/users/users_bloc.dart';
import 'package:notes/helpers/custom_dialog_account.dart';
import 'package:notes/widgets/boton_trasero.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class BackUpPage extends StatelessWidget {
  const BackUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final userBloc = BlocProvider.of<UsersBloc>(context);
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, userState) {
        return Scaffold(
          appBar: AppBar(
            leading: BotonTrasero(ontap: () => Navigator.pop(context)),
            backgroundColor: Colors.white,
            title: Text(
              location.copysecu,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.backup,
                  color: Colors.black,
                ),
                title: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    location.copyText,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userState.fecha.isEmpty
                      ? Text(location.noCopy)
                      : Text('${location.ultimaCopia}: ${userState.fecha}'),
                ),
                trailing: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    return MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.black,
                        child: Text(
                          location.save,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          notesBloc.cargarArchivos();
                          if (state.archives.isEmpty) {
                            Fluttertoast.showToast(msg: location.noArchive);
                          } else if (userState.fecha.isEmpty) {
                            CustomDialogAccount.loading(context);
                            await userBloc.buildBackup(
                                state.archives, userBloc, false);
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: 'Backup Completed');
                          } else {
                            CustomDialogAccount.loading(context);
                            await userBloc.buildBackup(
                                state.archives, userBloc, true);
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: 'Backup Completed');
                          }
                        });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.restore,
                  color: Colors.black,
                ),
                title: Text(location.restoreBack),
                trailing: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue[700],
                    child: Text(
                      location.restoreBackbuton,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      CustomDialogAccount.loading(context);
                      notesBloc.deleteAll();
                      await userBloc.getBackup(notesBloc);
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: location.completed);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
