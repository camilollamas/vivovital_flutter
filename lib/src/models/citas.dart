// To parse this JSON data, do
//
//     final cita = citaFromJson(jsonString);

import 'dart:convert';

Cita citaFromJson(String str) => Cita.fromJson(json.decode(str));

String citaToJson(Cita data) => json.encode(data.toJson());

class Cita {
    String? fecha;
    String? estadocit;
    int? cumplida;
    String? cancela;
    String? consecutivo;
    String? idplan;
    String? descplan;
    String? idservicio;
    String? descservicio;
    String? idemedica;
    String? descripcion;
    String? idmedico;
    String? nombre;
    String? verenlace;
    String? enlace;

    Cita({
        this.fecha,
        this.estadocit,
        this.cumplida,
        this.cancela,
        this.consecutivo,
        this.idplan,
        this.descplan,
        this.idservicio,
        this.descservicio,
        this.idemedica,
        this.descripcion,
        this.idmedico,
        this.nombre,
        this.verenlace,
        this.enlace,
    });

    factory Cita.fromJson(Map<String, dynamic> json) => Cita(
        fecha: json["FECHA"],
        estadocit: json["ESTADOCIT"],
        cumplida: json["CUMPLIDA"],
        cancela: json["CANCELA"],
        consecutivo: json["CONSECUTIVO"],
        idplan: json["IDPLAN"],
        descplan: json["DESCPLAN"],
        idservicio: json["IDSERVICIO"],
        descservicio: json["DESCSERVICIO"],
        idemedica: json["IDEMEDICA"],
        descripcion: json["DESCRIPCION"],
        idmedico: json["IDMEDICO"],
        nombre: json["NOMBRE"],
        verenlace: json["VERENLACE"],
        enlace: json["ENLACE"],
    );

    static List<Cita> fromJsonList(List<dynamic> jsonList){
    List<Cita> toList = [];
    for (var cit in jsonList) {
      Cita citas = Cita.fromJson(cit);
      toList.add(citas);
    }

    return toList;
  }

    Map<String, dynamic> toJson() => {
        "FECHA": fecha,
        "ESTADOCIT": estadocit,
        "CUMPLIDA": cumplida,
        "CANCELA": cancela,
        "CONSECUTIVO": consecutivo,
        "IDPLAN": idplan,
        "DESCPLAN": descplan,
        "IDSERVICIO": idservicio,
        "DESCSERVICIO": descservicio,
        "IDEMEDICA": idemedica,
        "DESCRIPCION": descripcion,
        "IDMEDICO": idmedico,
        "NOMBRE": nombre,
        "VERENLACE": verenlace,
        "ENLACE": enlace,
    };
}
