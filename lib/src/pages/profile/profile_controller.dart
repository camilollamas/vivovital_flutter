import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';
import '../../models/tgensel.dart';
import '../../models/json.dart';
import '../../models/response_api.dart';
import 'package:vivovital_app/src/providers/json_provider.dart';

class ProfileController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();

  List<Tgensel> epss =<Tgensel>[].obs;
  List<Tgensel> epSel =<Tgensel>[].obs;
  List<Tgensel> epsPrep =<Tgensel>[].obs;

  Tgensel Aseguradora = Tgensel();
  Tgensel prepagada = Tgensel();

  ProfileController(){
    print('Profile Controller -> User -> : ${user.toJson()}');
  }

  void onEditProfile(){
    // Get.toNamed('/home');
    // Get.removeRoute('/paid');
    // Get.offUntil('/paid', (route) => false);
    Get.offNamed('/update_profile');
  }

  void setValues(){
    print('====>  setValuesProfile <====');
    print('user.EPS => ${user.eps}');

    if(user.eps != null){
      getEPS();
    }


  }
  void getEPS() async{
    epSel.clear();
    epss.clear();
    Json json = Json(
        modelo:'SELKRY',
        metodo:'TGEN',
        parametros:{
          "WHERES":"TABLA = 'AFI' AND CAMPO ='EPS'"
        }
    );
    ResponseApi res = await jsonProvider.json(json);
    if(res.res == 'ok'){
      var result = Tgensel.fromJsonList(res.result?.recordsets![0]);
      epss.addAll(result);
      epSel.addAll(epss.where((e) => e.value == user.eps));
      Aseguradora = epSel[0];

      if(user.eps == 'Si'){
        epsPrep.addAll(epss.where((e) => e.value == user.eps));
        prepagada = epsPrep[0];
      }
      super.refresh();
    }

  }
}