import 'dart:convert';

FolderModel folderModelFromJson(String str) =>
    FolderModel.fromJson(json.decode(str));

String folderModelToJson(FolderModel data) => json.encode(data.toJson());

class FolderModel {
  FolderModel({
    this.id,
    required this.tipo,
    required this.clase,
    required this.nombre,
    this.imagen,
    this.selected,
    this.sub,
    this.titulo,
    this.cuerpo,
    required this.fecha,
    this.updated,
    this.time,
  });

  int? id;
  int? sub;
  int tipo;
  int? selected;
  int clase;
  String nombre;
  String? imagen;
  String? titulo;
  String? cuerpo;
  String fecha;
  String? updated;
  String? time;

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
        id: json["id"],
        sub: json["sub"],
        selected: json["selected"],
        tipo: json["tipo"],
        clase: json["clase"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        titulo: json["titulo"],
        cuerpo: json["cuerpo"],
        fecha: json["fecha"],
        updated: json["updated"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub": sub,
        "tipo": tipo,
        "selected": selected,
        "clase": clase,
        "nombre": nombre,
        "imagen": imagen,
        "titulo": titulo,
        "cuerpo": cuerpo,
        "fecha": fecha,
        "updated": updated,
        "time": time,
      };
}
