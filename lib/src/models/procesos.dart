// To parse this JSON data, do
//
//     final proceso = procesoFromJson(jsonString);

import 'dart:convert';

List<Proceso> procesoFromJson(String str) => List<Proceso>.from(json.decode(str).map((x) => Proceso.fromJson(x)));

String procesoToJson(List<Proceso> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proceso {
    Proceso({
        this.id,
        this.usuarioid,
        this.procesoid,
        this.poroceso,
        this.estado,
    });

    int? id;
    int? usuarioid;
    int? procesoid;
    String? poroceso;
    int? estado;


    factory Proceso.fromJson(Map<String, dynamic> json) => Proceso(
        id: json["id"],
        usuarioid: json["usuarioid"],
        procesoid: json["procesoid"],
        poroceso: json["poroceso"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuarioid": usuarioid,
        "procesoid": procesoid,
        "poroceso": poroceso,
        "estado": estado,
    };
}
