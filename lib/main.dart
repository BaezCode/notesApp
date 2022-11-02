import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/bloc/ImageData/imagedata_bloc.dart';
import 'package:notes/bloc/audiobloc/audio_bloc.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/bloc/pdfs/pdfs_bloc.dart';
import 'package:notes/bloc/subtask/subtask_bloc.dart';
import 'package:notes/bloc/task/task_bloc.dart';
import 'package:notes/bloc/users/users_bloc.dart';
import 'package:notes/helpers/navegar_fadein.dart';
import 'package:notes/l10n/l10n.dart';
import 'package:notes/models/task_models.dart';
import 'package:notes/pages/password_page.dart';
import 'package:notes/pages/task_options.dart';
import 'package:notes/routes/routes.dart';
import 'package:notes/screens/tabs_screen.dart';
import 'package:notes/services/local_notifications.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:flutter_gen/gen_l10n/notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotifications.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
  return runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesBloc(),
        ),
        BlocProvider(
          create: (context) => TaskBloc(),
        ),
        BlocProvider(
          create: (context) => ImagedataBloc(),
        ),
        BlocProvider(
          create: (context) => PdfsBloc(),
        ),
        BlocProvider(
          create: (context) => SubtaskBloc(),
        ),
        BlocProvider(
          create: (context) => AudioBloc(),
        ),
        BlocProvider(
          create: (context) => UsersBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _prefs = PreferenciasUsuario();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().actionStream.listen((event) {
      final decodedData = jsonDecode(event.payload!['model'].toString());
      final newTask = TaskModel(
          id: decodedData['id'],
          task: decodedData['task'],
          completed: decodedData['completed'],
          hoursSet: decodedData['hoursSet'],
          details: decodedData['details'],
          repeat: decodedData['repeat']);
      BlocProvider.of<SubtaskBloc>(context).add(LoadTask(
          newTask.id,
          newTask.task,
          newTask.completed,
          newTask.details,
          newTask.hoursSet, const []));
      navigatorKey.currentState
          ?.push(navegarFadeIn(context, TaskOptions(task: newTask)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        routes: appRoutes,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Good Note',
        home: BlocBuilder<PdfsBloc, PdfsState>(
          builder: (context, state) {
            if (_prefs.activepin && state.passwordData != _prefs.pinString) {
              return const PassWordPage();
            } else {
              return const TabsScreen();
            }
          },
        ));
  }
}
