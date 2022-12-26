import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';

class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomeController(){
    print('Home_Controller -> User : ${user.toJson()}');
  }

  void LogOut(){
    GetStorage().write('user', {});
    goToLoginPage();
  }
  void goToLoginPage() {
    Get.toNamed('/');
  }
}