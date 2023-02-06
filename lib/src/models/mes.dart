import 'dart:convert';

List<Mes> ciudadFromJson(String str) => List<Mes>.from(json.decode(str).map((x) => Mes.fromJson(x)));
String mesToJson(List<Mes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mes {
  Mes({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Mes.fromJson(Map<String, String> json) => Mes(
    id: json["id"],
    nombre: json["Nombre"],
  );

  static List<Mes> fromJsonList(List<dynamic> jsonList){
    List<Mes> toList = [];
    jsonList.forEach((item) {
      Mes mes = Mes.fromJson(item);
      toList.add(mes);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "Nombre": nombre,
  };
}