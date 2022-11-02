// To parse this JSON data, do
//
//     final pdfsModel = pdfsModelFromJson(jsonString);

import 'dart:convert';

PdfsModel pdfsModelFromJson(String str) => PdfsModel.fromJson(json.decode(str));

String pdfsModelToJson(PdfsModel data) => json.encode(data.toJson());

class PdfsModel {
  PdfsModel({
    this.id,
    required this.nombre,
    required this.fecha,
    required this.path,
  });

  int? id;
  String nombre;
  String fecha;
  String path;

  factory PdfsModel.fromJson(Map<String, dynamic> json) => PdfsModel(
        id: json["id"],
        nombre: json["nombre"],
        fecha: json["fecha"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "fecha": fecha,
        "path": path,
      };
}
