import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';

class UtilController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  UtilController(){
    // print('UtilController -> ${user.toJson()}');
  }
  void LogOut(){
    GetStorage().write('user', {});
    goToLoginPage();
  }
  void goToLoginPage() {
    Get.toNamed('/');
  }
  void goToRoute(String route){
    Get.toNamed('/${route ?? 'home'}');
  }
}