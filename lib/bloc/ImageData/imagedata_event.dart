part of 'imagedata_bloc.dart';

@immutable
abstract class ImagedataEvent {}

class SetImage extends ImagedataEvent {
  final List<String> imageData;

  SetImage(this.imageData);
}

class ExpandedImage extends ImagedataEvent {
  final bool expanded;

  ExpandedImage(this.expanded);
}

class ClearImage extends ImagedataEvent {}

class SetContenido extends ImagedataEvent {
  final String contenido;

  SetContenido(this.contenido);
}

class SetBarraTitle extends ImagedataEvent {
  final String titulo;

  SetBarraTitle(this.titulo);
}

class CargarImages extends ImagedataEvent {
  final List<String> imageData;

  final String contenido;
  final String titulo;
  CargarImages(this.contenido, this.titulo, this.imageData);
}
