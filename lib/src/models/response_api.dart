// To parse this JSON data, do
//
//     final responseApi = responseApiFromJson(jsonString);

import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  ResponseApi({
    this.res,
    this.result,
  });

  String? res;
  Result? result;

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    res: json["res"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "res": res,
    "result": result?.toJson(),
  };
}

class Result {
  Result({
    this.recordset,
    this.recordsets,
  });

  List<Recordset>? recordset;
  dynamic recordsets;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    //recordset: List<dynamic>.from(json["recordset"].map((x) => x)),
    recordset: List<Recordset>.from(json["recordset"].map((x) => Recordset.fromJson(x))),
    recordsets: List<dynamic>.from(json["recordsets"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "recordset": List<dynamic>.from(recordset!.map((x) => x)),
    "recordsets": List<dynamic>.from(recordsets!.map((x) => x)),
  };
}
class Recordset {
  Recordset({
    this.ok,
  });

  String? ok;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
    ok: json["OK"],
  );

  Map<String, dynamic> toJson() => {
    "OK": ok,
  };
}

