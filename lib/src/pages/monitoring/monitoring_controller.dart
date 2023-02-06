import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';

class MonitoringController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});




  MonitoringController(){
    print('Monitoring Controller -> User -> : ${user.toJson()}');
  }
}