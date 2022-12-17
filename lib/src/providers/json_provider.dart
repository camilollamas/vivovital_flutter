import 'package:get/get.dart';
import 'package:vivovital_app/src/enviroment/enviroment.dart';

import '../models/json.dart';

class JsonProvider extends GetConnect {
  String url = '${Enviroment.API_URL}json';

Future<Response> create(Json json) async {
  print('JSONProvider ${json}');
  Response response = await post(
      url,
      json.toJson(),
      headers: {
        'Content-Type': 'application/json'
      }
  );

  return response;
}
}