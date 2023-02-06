import 'dart:convert';

List<Departamentos> departamentosFromJson(String str) => List<Departamentos>.from(json.decode(str).map((x) => Departamentos.fromJson(x)));



String departamentosToJson(List<Departamentos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Departamentos {
  Departamentos({
    this.dpto,
    this.nombre,
  });

  String? dpto;
  String? nombre;

  factory Departamentos.fromJson(Map<String, dynamic> json) => Departamentos(
    dpto: json["DPTO"],
    nombre: json["NOMBRE"],
  );

  static List<Departamentos> fromJsonList(List<dynamic> jsonList){
    List<Departamentos> toList = [];
    jsonList.forEach((dep) {
      Departamentos departamento = Departamentos.fromJson(dep);
      toList.add(departamento);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "DPTO": dpto,
    "NOMBRE": nombre,
  };
}