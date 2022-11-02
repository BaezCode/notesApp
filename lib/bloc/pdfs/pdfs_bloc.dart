import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:notes/models/pdfs_model.dart';
import 'package:notes/services/db_pdfs.dart';

part 'pdfs_event.dart';
part 'pdfs_state.dart';

class PdfsBloc extends Bloc<PdfsEvent, PdfsState> {
  DateTime now = DateTime.now();

  List<PdfsModel> pdfs = [];

  PdfsBloc() : super(PdfsState()) {
    on<SetPdfs>((event, emit) {
      emit(state.copyWith(pdfs: event.pdfs));
    });
    on<ActivePassword>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<SetPasswordData>((event, emit) {
      emit(state.copyWith(passwordData: event.passwordData));
    });
  }

  void cargarArchivos() async {
    final pdfs = await DBPdfs.db.getTodosLosPdfs();
    this.pdfs = [...pdfs];
    add(SetPdfs(pdfs));
  }

  Future<void> nuevoFolder(String nombre, String path) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    var _random = Random();

    final nuevoFolder = PdfsModel(
        id: _random.nextInt(1100000),
        nombre: nombre,
        fecha: formattedDate,
        path: path);

    final id = await DBPdfs.db.nuevoPdfs(nuevoFolder);

    nuevoFolder.id = id;
    pdfs.add(nuevoFolder);
    cargarArchivos();
  }

  void borrarPdf(id) async {
    await DBPdfs.db.deletePfs(id);
    cargarArchivos();
  }
}
