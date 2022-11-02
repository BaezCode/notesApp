part of 'imagedata_bloc.dart';

class ImageDataState {
  final List<String> images;
  final bool expanded;
  final String contenido;
  final String titulo;

  ImageDataState({
    this.images = const [],
    this.expanded = false,
    this.contenido = 'Images Notes',
    this.titulo = 'Images',
  });

  ImageDataState copyWith({
    List<String>? images,
    bool? expanded,
    String? contenido,
    String? titulo,
    bool? appBarActive,
  }) =>
      ImageDataState(
        images: images ?? this.images,
        expanded: expanded ?? this.expanded,
        contenido: contenido ?? this.contenido,
        titulo: titulo ?? this.titulo,
      );
}
