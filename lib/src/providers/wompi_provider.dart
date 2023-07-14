import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vitalhelp_app/src/enviroment/enviroment.dart';
import '../models/json.dart';
import '../models/response_api.dart';

// import "package:http/http.dart" as http;

class WompiProvider extends GetConnect {
  
  String url = 'https://sandbox.wompi.co/v1/';

  Future<dynamic> acceptance_token(String UrlWompi, String pub_key) async {
    dynamic response = await get(
        '${UrlWompi}merchants/${pub_key}',
        headers: {
          'Content-Type': 'application/json'
        }
    );
    print('acceptance_token => acceptance_token ${response.body}');
    if(response.body == null){
      return {"status":"ERROR"};
    }
    // ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return response.body;
  }

  Future<dynamic> create_card(String UrlWompi, Map data, String pub_key) async {
    print(data);
    dynamic response = await post(
        '${UrlWompi}/tokens/cards',
        data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${pub_key}',
        }
    );
    print('create_card =>  ${response.body}');
    if(response.statusCode == 201){
      return response.body;
    }else{
      return {"status":"ERROR"};
    }

  }

  Future<dynamic> create_pay_source(String UrlWompi, Map data, String prv_key) async {
    print('create_pay_source data: $data');
    print('create_pay_source prv_key: $prv_key');
    dynamic response = await post(
        '${UrlWompi}/payment_sources',
        data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prv_key}',
        }
    );
    print('wompi_provider => create_pay_source statusCode ${response.statusCode}');
    print('wompi_provider => create_pay_source body ${response.body}');

    if(response.statusCode == 201){
      return response.body;
    }else{
      return {"status":"ERROR"};
    }
  }

  Future<dynamic> create_transaction(String UrlWompi, Map data, String prv_key) async {
    dynamic response = await post(
        '${UrlWompi}/transactions/',
        data,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prv_key}',
        }
    );
    print('wompi_provider => create_transaction statusCode ${response.statusCode}');
    print('wompi_provider => create_transaction body ${response.body}');

    if(response.statusCode == 201){
      return response.body;
    }else{
      return {"status":"ERROR"};
    }
  }

  Future<dynamic> get_transactions(String UrlWompi, String id) async {
    dynamic response = await get(
        '${UrlWompi}transactions/${id}',
        headers: {
          'Content-Type': 'application/json'
        }
    );
    print('get_transactions => get_transactions ${response.body}');
    if(response.body == null){
      return {"status":"ERROR"};
    }
    // ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return response.body;
  }
}