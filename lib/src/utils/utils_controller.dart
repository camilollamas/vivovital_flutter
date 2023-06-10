import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';

class UtilController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  UtilController(){
    print('Entrando en UtilController ');
    // print('UtilController -> ${user.toJson()}');
  }
  void LogOut(){
    GetStorage().remove('user');
    // goToLoginPage();

    // Get.offAll(
    //     // Get.toNamed('/')
    // );
    Get.offNamedUntil('/', (route) => false);
  }
  void goToLoginPage() {

  }
  void goToRoute(String route){
    Get.toNamed('/${route ?? 'home'}');
  }
}