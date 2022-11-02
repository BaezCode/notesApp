import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/helpers/custom_dialog_account.dart';
import 'package:notes/screens/home_page.dart';
import 'package:notes/screens/task_page.dart';
import 'package:notes/widgets/custom_nav.dart';
import 'package:notes/widgets/drawer_home.dart';
import 'package:notes/widgets/floating_button.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;
    final List<String> _nombres = [
      location.notes,
      location.task,
    ];

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
            drawer: state.indexHome == 0 ? const DrawerHome() : null,
            bottomNavigationBar: CustomNav(index: state.indexHome),
            floatingActionButton: Floatingnotes(
              index: state.indexHome,
              tipo: 1,
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      final token =
                          await FirebaseAuth.instance.currentUser?.getIdToken();
                      if (token == null) {
                        CustomDialogAccount.buildMenuRegister(context);
                      } else {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            CustomDialogAccount.builUserInterface(context);
                          }
                        } on SocketException catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            children: [
                              Text(location.conecction),
                              const Spacer(),
                              const Icon(
                                CupertinoIcons.wifi_exclamationmark,
                                color: Colors.white,
                              )
                            ],
                          )));
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.account_box_rounded,
                      size: 30,
                    )),
              ],
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 1,
              backgroundColor: Colors.white,
              title: Text(
                _nombres[state.indexHome],
                style: const TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            body: _HomePageBody(state: state));
      },
    );
  }
}

class _HomePageBody extends StatelessWidget {
  final NotesState state;
  const _HomePageBody({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final taskBloc = BlocProvider.of<TaskBloc>(context);

    switch (state.indexHome) {
      case 0:
        state.groupValue == 0
            ? notesBloc.cargarArchivos()
            : notesBloc.cargarScanPorTipo(state.groupValue);
        return const HomePage();
      case 1:
        taskBloc.cargarScanPorTipo(0);
        return const TaskPage();
      default:
        return const HomePage();
    }
  }
}
