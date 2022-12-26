// To parse this JSON data, do
//
//     final responseApi = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.idafiliado,
    this.pnombre,
    this.snombre,
    this.papellido,
    this.sapellido,
    this.celular,
    this.telefonores,
    this.email,
    this.sexo,
    this.tipoDoc,
    this.docidafiliado,
    this.empresa,
    this.aseguradora,
    this.fnacimiento,
    this.edad,
    this.ciudad,
    this.nombreciu,
    this.direccion,
    this.departamento,
    this.dpto,
    this.codpais,
    this.nombrecompleto,
    this.documentocompleto,
    this.estadoCivil,
    this.idocupacion,
    this.ocupacion,
    this.idescolaridad,
    this.escolaridad,
    this.idadministradora,
    this.idtipoafiliacion,
    this.tipoafiliacion,
    this.idclaseafiliacion,
    this.coberturaSalud,
    this.okbd,
    this.idplan,
    this.descplan,
    this.noadmision,
    this.estadoHadm,
  });

  String? idafiliado;
  String? pnombre;
  String? snombre;
  String? papellido;
  String? sapellido;
  String? celular;
  String? telefonores;
  String? email;
  String? sexo;
  String? tipoDoc;
  String? docidafiliado;
  String? empresa;
  String? aseguradora;
  String? fnacimiento;
  String? edad;
  String? ciudad;
  String? nombreciu;
  String? direccion;
  String? departamento;
  String? dpto;
  String? codpais;
  String? nombrecompleto;
  String? documentocompleto;
  String? estadoCivil;
  String? idocupacion;
  String? ocupacion;
  String? idescolaridad;
  String? escolaridad;
  String? idadministradora;
  String? idtipoafiliacion;
  String? tipoafiliacion;
  String? idclaseafiliacion;
  String? coberturaSalud;
  int? okbd;
  String? idplan;
  String? descplan;
  String? noadmision;
  String? estadoHadm;

  factory User.fromJson(Map<String, dynamic> json) => User(
    idafiliado: json["IDAFILIADO"],
    pnombre: json["PNOMBRE"],
    snombre: json["SNOMBRE"],
    papellido: json["PAPELLIDO"],
    sapellido: json["SAPELLIDO"],
    celular: json["CELULAR"],
    telefonores: json["TELEFONORES"],
    email: json["EMAIL"],
    sexo: json["SEXO"],
    tipoDoc: json["TIPO_DOC"],
    docidafiliado: json["DOCIDAFILIADO"],
    empresa: json["EMPRESA"],
    aseguradora: json["ASEGURADORA"],
    fnacimiento: json["FNACIMIENTO"],
    edad: json["EDAD"],
    ciudad: json["CIUDAD"],
    nombreciu: json["NOMBRECIU"],
    direccion: json["DIRECCION"],
    departamento: json["DEPARTAMENTO"],
    dpto: json["DPTO"],
    codpais: json["CODPAIS"],
    nombrecompleto: json["NOMBRECOMPLETO"],
    documentocompleto: json["DOCUMENTOCOMPLETO"],
    estadoCivil: json["ESTADO_CIVIL"],
    idocupacion: json["IDOCUPACION"],
    ocupacion: json["OCUPACION"],
    idescolaridad: json["IDESCOLARIDAD"],
    escolaridad: json["ESCOLARIDAD"],
    idadministradora: json["IDADMINISTRADORA"],
    idtipoafiliacion: json["IDTIPOAFILIACION"],
    tipoafiliacion: json["TIPOAFILIACION"],
    idclaseafiliacion: json["IDCLASEAFILIACION"],
    coberturaSalud: json["COBERTURA_SALUD"],
    okbd: json["OKBD"],
    idplan: json["IDPLAN"],
    descplan: json["DESCPLAN"],
    noadmision: json["NOADMISION"],
    estadoHadm: json["ESTADO_HADM"],
  );

  Map<String, dynamic> toJson() => {
    "IDAFILIADO": idafiliado,
    "PNOMBRE": pnombre,
    "SNOMBRE": snombre,
    "PAPELLIDO": papellido,
    "SAPELLIDO": sapellido,
    "CELULAR": celular,
    "TELEFONORES": telefonores,
    "EMAIL": email,
    "SEXO": sexo,
    "TIPO_DOC": tipoDoc,
    "DOCIDAFILIADO": docidafiliado,
    "EMPRESA": empresa,
    "ASEGURADORA": aseguradora,
    "FNACIMIENTO": fnacimiento,
    "EDAD": edad,
    "CIUDAD": ciudad,
    "NOMBRECIU": nombreciu,
    "DIRECCION": direccion,
    "DEPARTAMENTO": departamento,
    "DPTO": dpto,
    "CODPAIS": codpais,
    "NOMBRECOMPLETO": nombrecompleto,
    "DOCUMENTOCOMPLETO": documentocompleto,
    "ESTADO_CIVIL": estadoCivil,
    "IDOCUPACION": idocupacion,
    "OCUPACION": ocupacion,
    "IDESCOLARIDAD": idescolaridad,
    "ESCOLARIDAD": escolaridad,
    "IDADMINISTRADORA": idadministradora,
    "IDTIPOAFILIACION": idtipoafiliacion,
    "TIPOAFILIACION": tipoafiliacion,
    "IDCLASEAFILIACION": idclaseafiliacion,
    "COBERTURA_SALUD": coberturaSalud,
    "OKBD": okbd,
    "IDPLAN": idplan,
    "DESCPLAN": descplan,
    "NOADMISION": noadmision,
    "ESTADO_HADM": estadoHadm,
  };
}
