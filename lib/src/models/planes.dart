import 'dart:convert';

Planes planesFromJson(String str) => Planes.fromJson(json.decode(str));

String planesToJson(Planes data) => json.encode(data.toJson());

class Planes {
  Planes({
    required this.idplan,
    required this.descplan,
    required this.estado,
    required this.valor,
  });

  String idplan;
  String descplan;
  String estado;
  int valor;

  factory Planes.fromJson(Map<String, dynamic> json) => Planes(
    idplan: json["IDPLAN"],
    descplan: json["DESCPLAN"],
    estado: json["ESTADO"],
    valor: json["VALOR"],
  );

  static List<Planes> fromJsonList(List<dynamic> jsonList){
    List<Planes> toList = [];
    jsonList.forEach((pln) {
      Planes planes = Planes.fromJson(pln);
      toList.add(planes);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "IDPLAN": idplan,
    "DESCPLAN": descplan,
    "ESTADO": estado,
    "VALOR": valor,
  };
}
