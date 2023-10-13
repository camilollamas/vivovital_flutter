// To parse this JSON data, do
//
//     final alerta = alertaFromJson(jsonString);

import 'dart:convert';

Alerta alertaFromJson(String str) => Alerta.fromJson(json.decode(str));

String alertaToJson(Alerta data) => json.encode(data.toJson());

class Alerta {
  Alerta({
    this.iddos,
    this.idmes,
    this.numero,
    this.clase,
    this.tipo,
    this.titulo,
    this.descripcion,
    this.iddocs,
  });

  int? iddos;
  int? idmes;
  String? numero;
  int? clase;
  String? tipo;
  String? titulo;
  String? descripcion;
  String? iddocs;

  static List<Alerta> fromJsonList(List<dynamic> jsonList){
    List<Alerta> toList = [];
    for (var ale in jsonList) {
      Alerta alertas = Alerta.fromJson(ale);
      toList.add(alertas);
    }

    return toList;
  }

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
    iddos: json["IDDOS"],
    idmes: json["IDMES"],
    numero: json["NUMERO"],
    clase: json["CLASE"],
    tipo: json["TIPO"],
    titulo: json["TITULO"],
    descripcion: json["DESCRIPCION"],
    iddocs: json["IDDOCS"],
  );

  Map<String, dynamic> toJson() => {
    "IDDOS": iddos,
    "IDMES": idmes,
    "NUMERO": numero,
    "CLASE": clase,
    "TIPO": tipo,
    "TITULO": titulo,
    "DESCRIPCION": descripcion,
    "IDDOCS": iddocs,
  };
}
