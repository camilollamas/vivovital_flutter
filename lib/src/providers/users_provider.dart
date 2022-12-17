import 'package:get/get.dart';
import 'package:vivovital_app/src/enviroment/enviroment.dart';

import '../models/user.dart';

class UserProvider extends GetConnect {
  String url = '${Enviroment.API_URL}json';

Future<Response> create(User user) async {
  Response response = await post(
      url,
      user.toJson(),
      headers: {
        'Content-Type': 'application/json'
      }
  );

  return response;
}
}