// To parse this JSON data, do
//
//     final admision = admisionFromJson(jsonString);

import 'dart:convert';

Admision admisionFromJson(String str) => Admision.fromJson(json.decode(str));

String admisionToJson(Admision data) => json.encode(data.toJson());

class Admision {
    Admision({
        this.id,
        this.usuarioid,
        this.programaid,
        this.estado,
    });

    int? id;
    int? usuarioid;
    int? programaid;
    String? estado;


    factory Admision.fromJson(Map<String, dynamic> json) => Admision(
        id: json["id"],
        usuarioid: json["usuarioid"],
        programaid: json["programaid"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuarioid": usuarioid,
        "programaid": programaid,
        "estado": estado,
    };
}