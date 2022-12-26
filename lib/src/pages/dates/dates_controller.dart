import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';

class DatesController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  DatesController(){
    print('Dates Controller -> User -> : ${user.toJson()}');
  }
}