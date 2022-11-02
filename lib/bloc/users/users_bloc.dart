import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:notes/bloc/notes/notes_bloc.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/shared/preferencias_usuario.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  DateTime now = DateTime.now();
  final User? user = FirebaseAuth.instance.currentUser;
  UsersBloc() : super(UsersState()) {
    on<SetdataRegister>((event, emit) {
      emit(state.copyWith(register: event.register));
    });
    on<SetFecha>((event, emit) {
      emit(state.copyWith(fecha: event.fecha));
    });
  }

  Future<void> buildBackup(
      List<FolderModel> list, UsersBloc usersBloc, bool update) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    final _prefs = PreferenciasUsuario();
    if (update) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user!.uid)
          .update({'data': FieldValue.delete()});
    }
    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user!.uid)
          .set(
        {
          'nombre': _prefs.name,
          'email': _prefs.email,
          'fecha': formattedDate,
          'data': FieldValue.arrayUnion([
            {
              'id': element.id,
              'clase': element.clase,
              'cuerpo': element.cuerpo,
              'fecha': element.fecha,
              'imagen':
                  element.imagen!.isEmpty ? '' : jsonDecode(element.imagen!),
              'nombre': element.nombre,
              'titulo': element.titulo,
              'time': element.time
            }
          ])
        },
        SetOptions(merge: true),
      );
      usersBloc.add(SetFecha(formattedDate));
    });
  }

  Future<List<String>> storeImages(String? imagen) async {
    try {
      if (imagen!.isEmpty) {
        return [];
      } else {
        final List<dynamic> decodeData = jsonDecode(imagen);
        List<String> imageUrl = [];
        // ignore: avoid_function_literals_in_foreach_calls
        decodeData.forEach((element) async {
          imageUrl.add(element);
        });

        return imageUrl;
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> getBackup(NotesBloc notesBloc) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .get()
        .then((value) => {
              // ignore: avoid_function_literals_in_foreach_calls
              List.from(value['data']).forEach((element) {
                switch (element['clase']) {
                  case 1:
                    notesBloc.nuevoFolder(
                        1,
                        element['nombre'],
                        element['clase'],
                        element['cuerpo'],
                        element['imagen'],
                        '');

                    break;
                  case 2:
                    notesBloc.nuevoFolder(
                        1,
                        element['nombre'],
                        element['clase'],
                        element['cuerpo'],
                        element['imagen'].isEmpty
                            ? ''
                            : jsonEncode(List.from(element['imagen'])),
                        '');

                    break;
                  case 3:
                    notesBloc.nuevoFolder(
                        0,
                        element['nombre'],
                        element['clase'],
                        element['cuerpo'],
                        element['imagen'],
                        element['time']);
                    break;
                  default:
                }
              })
            });
  }
}
