// To parse this JSON data, do
//
//     final notificacion = notificacionFromJson(jsonString);

import 'dart:convert';

List<Notificacion> notificacionFromJson(String str) => List<Notificacion>.from(json.decode(str).map((x) => Notificacion.fromJson(x)));

String notificacionToJson(List<Notificacion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notificacion {
  int? id;
  int? idapm;
  int? dia;
  String? fecha;
  List<dynamic>? notif;

  Notificacion({
    this.id,
    this.idapm,
    this.dia,
    this.fecha,
    this.notif,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
    id: json["ID"],
    idapm: json["IDAPM"],
    dia: json["DIA"],
    fecha: json["FECHA"],
    notif: List<dynamic>.from(json["NOTIF"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "IDAPM": idapm,
    "DIA": dia,
    "FECHA": fecha,
    "NOTIF": List<dynamic>.from(notif!.map((x) => x)),
  };
}