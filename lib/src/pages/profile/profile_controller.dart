import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import '../../models/tgensel.dart';
import '../../models/json.dart';
import '../../models/response_api.dart';
import 'package:vitalhelp_app/src/providers/json_provider.dart';

class ProfileController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();

  List<Tgensel> epss =<Tgensel>[].obs;
  List<Tgensel> epSel =<Tgensel>[].obs;
  List<Tgensel> epsPrep =<Tgensel>[].obs;

  Tgensel Aseguradora = Tgensel();
  Tgensel prepagada = Tgensel();

  ProfileController(){
    if(kDebugMode){
      print('Profile Controller -> User -> : ${user.toJson()}');
    }
  }

  void onEditProfile(){
    // Get.toNamed('/home');
    // Get.removeRoute('/paid');
    // Get.offUntil('/paid', (route) => false);
    Get.offNamed('/update_profile');
  }

  void setValues(){
    if(kDebugMode){
      print('====>  setValuesProfile <====');
      print('user.EPS => ${user.aseguradora}');
    }
    if(user.aseguradora != null){
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
      epSel.addAll(epss.where((e) => e.value == user.aseguradora));
      Aseguradora = epSel[0];

      if(user.idclaseafiliacion == 'Si'){
        epsPrep.addAll(epss.where((e) => e.value == user.coberturaSalud));
        prepagada = epsPrep[0];
      }
      super.refresh();
    }

  }
}