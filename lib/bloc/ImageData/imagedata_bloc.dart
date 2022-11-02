import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'imagedata_event.dart';
part 'imagedata_state.dart';

class ImagedataBloc extends Bloc<ImagedataEvent, ImageDataState> {
  DateTime now = DateTime.now();
  List<String> images = [];

  ImagedataBloc() : super(ImageDataState()) {
    on<SetImage>((event, emit) {
      emit(state.copyWith(
        images: event.imageData,
      ));
    });
    on<CargarImages>((event, emit) {
      emit(state.copyWith(
          contenido: event.contenido,
          titulo: event.titulo,
          images: event.imageData));
    });
    on<ExpandedImage>((event, emit) {
      emit(state.copyWith(expanded: event.expanded));
    });
    on<ClearImage>((event, emit) {
      emit(state.copyWith(titulo: 'Images', contenido: '', images: []));
    });
    on<SetContenido>((event, emit) {
      emit(state.copyWith(expanded: false, contenido: event.contenido));
    });

    on<SetBarraTitle>((event, emit) {
      emit(state.copyWith(titulo: event.titulo));
    });
  }

  void clear() {
    if (images.isNotEmpty) {
      images.clear();
      add(ClearImage());
    } else {
      add(ClearImage());
    }
  }

  Future<void> nuevoFolder(String image) async {
    images.add(image);
    add(SetImage(images));
  }

  void loadImages(
      String contenido, String titulo, List<dynamic> decodeData) async {
    for (var element in decodeData) {
      images.add(element);
      add(CargarImages(contenido, titulo, images));
    }
  }
}
