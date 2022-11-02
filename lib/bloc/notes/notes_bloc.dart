import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/folder_model.dart';
import 'package:notes/services/db_services.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  DateTime now = DateTime.now();
  List<FolderModel> archives = [];
  Map<String, TextStyle> patter = {};

  NotesBloc() : super(NotesState()) {
    on<SetNotes>((event, emit) {
      emit(state.copyWith(archives: event.archives));
    });
    on<SelectIndex>((event, emit) {
      emit(state.copyWith(indexHome: event.selectIndex));
    });
    on<SetTitulo>((event, emit) {
      emit(state.copyWith(titulo: event.titulo));
    });
    on<AppBarActive>((event, emit) {
      emit(state.copyWith(appBarActive: event.appBarActive));
    });
    on<SetTextSize>((event, emit) {
      emit(state.copyWith(textSize: event.textSize));
    });

    on<ChargeData>((event, emit) {
      emit(state.copyWith(
        updated: event.updated,
        titulo: event.titulo,
      ));
    });
    on<ClearNotes>((event, emit) {
      emit(state.copyWith(
        updated: false,
        titulo: 'Title',
      ));
    });
    on<GroupValue>((event, emit) {
      emit(state.copyWith(groupValue: event.groupValue));
    });
    on<OrderValue>((event, emit) {
      emit(state.copyWith(orderValue: event.orderValue));
    });
    on<ActivePin>((event, emit) {
      emit(state.copyWith(activePin: event.activePin));
    });
  }

  void cargarArchivos() async {
    final archives = await DBProvider.db.getTodosLosScans();
    this.archives = [...archives];
    add(SetNotes(archives));
  }

  void borrarScanPorId(id, int tipo) async {
    await DBProvider.db.deleteScan(id);
    cargarArchivos();
  }

  void deleteAll() async {
    await DBProvider.db.deleteAllScans();
    cargarArchivos();
  }

  cargarScanPorTipo(int tipo) async {
    final archives = await DBProvider.db.getScansPorTipo(tipo);
    this.archives = [...archives];
    add(SetNotes(archives));
  }

  Future selectedIndex(int index) async {
    add(SelectIndex(index));
  }

  Future<FolderModel> nuevoFolder(int tipo, String nombre, int clase,
      String cuerpo, String image, String time) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    var _random = Random();

    final nuevoFolder = FolderModel(
        cuerpo: cuerpo,
        imagen: image,
        id: _random.nextInt(1100000),
        selected: 0,
        tipo: tipo,
        sub: _random.nextInt(100000000) * 5,
        clase: clase,
        nombre: nombre,
        fecha: formattedDate,
        time: time);

    final id = await DBProvider.db.nuevoFolder(nuevoFolder);

    nuevoFolder.id = id;
    archives.add(nuevoFolder);
    cargarArchivos();

    return nuevoFolder;
  }

  Future<void> updateScan(prodData, String titulo, String cuerpo, int tipo,
      String? images, String? time) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    final nuevoFolder = FolderModel(
        id: prodData.id,
        tipo: prodData.tipo,
        clase: prodData.clase,
        nombre: titulo,
        titulo: titulo,
        imagen: images,
        selected: 0,
        cuerpo: cuerpo,
        fecha: formattedDate,
        time: time);

    await DBProvider.db.updateScan(nuevoFolder);

    cargarArchivos();
  }
}
