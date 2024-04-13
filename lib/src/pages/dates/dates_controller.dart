import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import 'package:load/load.dart';

import 'package:vitalhelp_app/src/providers/json_provider.dart';
import 'package:vitalhelp_app/src/models/json.dart';
import 'package:vitalhelp_app/src/models/response_api.dart';

import '../../models/dias.dart';
import '../../models/horas.dart';
import '../../models/citas.dart';

class DatesController extends GetxController {
  
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();

  var citaValoracion = {}.obs;
  var mostrarAgenda = '0'.obs;
  var haveDates = false.obs;

  List<DateTime> diasDisponibles = <DateTime>[].obs;
  DateTime currentDate = DateTime.now().obs.value;

  var idDia = ''.obs;
  List<Dia> diasOpt = <Dia>[].obs;

  var idHora = ''.obs;
  List<Hora> horasOpt = <Hora>[].obs;

  List<Cita> citas = [];
  var showCitas = false.obs;

  DatesController(){
    idDia = ''.obs;
    idHora = ''.obs;
    diasOpt.clear();
    horasOpt.clear();

    getStatus();
  }

  void getStatus() async {
    showLoadingDialog();
    showCitas.value = false;
    mostrarAgenda.value = '0';
    idDia = ''.obs;
    idHora = ''.obs;

    diasOpt.clear();
    horasOpt.clear();


    var idafiliado = user.toJson();
    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'GETSTATUS',
        parametros: {
          "IDAFILIADO": '${idafiliado['IDAFILIADO']}'
        });

    ResponseApi res = await jsonProvider.json(json);

    List<dynamic> estadoUser = res.result?.recordsets![0];

    var cV = estadoUser.where((objeto) => objeto['PASO'] == '0030').toList();
    citaValoracion.value = cV[0];
    hideLoadingDialog();

    // ignore: invalid_use_of_protected_member
    if( citaValoracion.value['ESTADOPASO'] == 0 ){
      getDays();
      mostrarAgenda.value = '1';
    }else{
      getDays();
      getDates();
    }

  }
  void getDays() async{
    idHora = ''.obs;
    horasOpt.clear();
    showLoadingDialog();

    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'CONSULTA_DIAS',
        parametros: {});
    ResponseApi res = await jsonProvider.json(json);

    if(res.res == 'ok') {
    // print('res => ${res.result?.recordsets![0]}');
    // Validar si hay citas
    if(res.result?.recordsets![0]?.isNotEmpty ?? false) {
      var dias = Dia.fromJsonList(res.result?.recordsets![0]!);
      diasDisponibles = dias.map((item) {
        DateTime date = DateTime.parse(item.dia!);
        return date;
      }).toList();
      currentDate = diasDisponibles[0];
      haveDates.value = true;
      
    } else {
      // No hay citas disponibles
      if(kDebugMode){
        print('No hay citas disponibles');
      }
      // Aquí puedes mostrar un mensaje de "No hay citas"
    }
  }
    hideLoadingDialog();
  }

  void getHoras(day) async{
    if(day == null){
      return;
    }
    
    idHora = ''.obs;
    horasOpt.clear();
    showLoadingDialog();

    Json json = Json(
        modelo: 'VIVO_AFI_APP',
        metodo: 'CONSULTA_HORA',
        parametros: {
          "DIA": "$day"
        });
    ResponseApi res = await jsonProvider.json(json);

    if(res.res == 'ok'){
      var reshoras = Hora.fromJsonList(res.result?.recordsets![0]);
      horasOpt.addAll(reshoras);
    }
    hideLoadingDialog();
  }
  void onAgendar() async{
    showLoadingDialog();

    Json json = Json(
      modelo: 'VIVO_CIT',
      metodo: 'AGENDAR',
      parametros: {
        "IDAFILIADO": "${user.idafiliado}",
        // "consecutivo": "${citaValoracion.value['IDCITA']}",
        "CONSECUTIVO": "$idHora",
        "TIPOCITA": "VALORACION"
        // "IDAFILIADO": '${idafiliado['IDAFILIADO']}'
      }
    );

    // print(json.toJson());
    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();

    if(res.res == 'ok'){
      if(res.result?.recordset![0].ok == 'OK'){
        Get.snackbar(
          'Cita agendada',
          'Su cita ha sido agendada correctamente.',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.done,
            color: Colors.white, // Color del icono
          ),
        );  
        getStatus();
      }else{
        List error = res.result?.recordsets![1];
        Map detail = error[0];
        Get.snackbar(
            'Aviso: ',
            detail['ERROR'],
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white, // Color del icono
            ),
        );
      }

    }else{
      hideLoadingDialog();
      Get.snackbar(
        'Aviso: ',
        'No se pudo agendar su cita',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white, // Color del icono
        ),
      );
    }
  }
  void getDates() async{
    citas.clear();
    // showLoadingDialog();
    Json json = Json(
        modelo: 'VIVO_CIT',
        metodo: 'CITAS_AFI',
        parametros: {
          "IDAFILIADO": "${user.idafiliado}"
        });
    ResponseApi res = await jsonProvider.json(json);
    citas.clear();
    if(res.res == 'ok'){
      // print('[1] citas - citas => ${res.result?.recordsets![0]}');
      var resu = Cita.fromJsonList(res.result?.recordsets![0]);
      // print('citas.length ${citas.length}');

      citas.clear();
      citas.addAll(resu);

      showCitas.value = true;
      //validate if have citas
        super.refresh();
      if(citas.isNotEmpty){
        showCitas.value = true;
        super.refresh();
      }
    }
    // hideLoadingDialog();
  }
  void onCancelarCita(Cita cit) async{
    // print('cita => ${cit.toJson()}');
    showLoadingDialog();
    Json json = Json(
        modelo: 'VIVO_CIT',
        metodo: 'CANCELAR',
        parametros: {
          "CONSECUTIVO": "${cit.consecutivo}",
          "IDAFILIADO": "${user.idafiliado}"
        });
    ResponseApi res = await jsonProvider.json(json);

    hideLoadingDialog();
    if(res.res == 'ok'){
      // Get.back();
      showCitas.value = false;
      //validate if have citas
      Get.snackbar('Cita Cancelada',
        'Se ha cancelado la cita exitosamente.',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.done,
          color: Colors.white
        )
      );  

      citas.clear();
      super.refresh();
      getStatus();
    }else{
      Get.snackbar(
        'Error',
        'No se pudo cancelar su cita.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white
        )
      );  
    }
  }
  
  Future<List<Cita>> getPlanes() async {
    // print('Devolviendo planes=> ${citas.toString()}');
    return citas;
  }
}