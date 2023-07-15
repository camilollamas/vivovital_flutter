import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vitalhelp_app/src/models/user.dart';

import '../../models/alerta.dart';
import '../../models/response_api.dart';
import '../../models/notification.dart';
import '../../providers/json_provider.dart';
import '../../models/json.dart';

import 'package:video_player/video_player.dart';

class NotificationsController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  JsonProvider jsonProvider = JsonProvider();
  Notificacion notificacion = Notificacion();
  late final tabController;

  List<Alerta> notify = [];

  var titleVideo= ''.obs;
  var descVideo= ''.obs;
  var urlVideo= ''.obs;

  var selectedDate = DateTime.now().obs;
  var showNotify = false.obs;
  @override
  void onInit(){
    super.onInit();
  }

  @override
  void onReady(){
    super.onReady();
  }

  chooseDate() async{
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2024),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    // brightness: brightness,
                    primary: Color(0xFF243588),
                    onPrimary: Colors.white, //Color(0xFF465DC9),
                    // secondary: secondary,
                    // onSecondary: onSecondary,
                    // error: error,
                    // onError: onError,
                    // background: background,
                    // onBackground: onBackground,
                    onSurface: Color(0xFF882451),
                    // Surface: onSurface
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Color(0xFF243588),
                  )
                )
              ),
              child: child!
          );
        },

    );
    if(pickedDate!=null && pickedDate!=selectedDate.value){
      selectedDate.value = pickedDate;
    }
    getDay();
    super.refresh();
  }

  void getDay() async{
    notify.clear();
    showNotify.value = false;
    print('====> getDay <====');
    String date = selectedDate.value.toString();
    print('====> FECHA: ${date.substring(0,10)}');
    print('====> IDAFILIADO: ${user.idafiliado}');

    showLoadingDialog();
    Json json = Json(
        modelo: 'NOTIFICACIONES',
        metodo: 'GET_DIA',
        parametros: {
          "FECHA": "${date.substring(0,10)}",
          "IDAFILIADO": "${user.idafiliado}"
        }
    );

    ResponseApi res = await jsonProvider.json(json);
    hideLoadingDialog();
    Map <String, dynamic> result = res.result?.recordsets![0][0];
    if(result!=null && result['RESULT'] != null ){
      var data = result['RESULT'];
      var not = notificacionFromJson(data);
      List? asd = not[0].notif;
      var alertas = Alerta.fromJsonList(asd!);

      notify.addAll(alertas!);
      showNotify.value= true;
    }
    super.refresh();
    print('====> getDay Out <====');
  }
  Future<List<Alerta>> sendNotify() async {
    print('sendNotify =>${notify.toString()}');
    return notify;
  }

  Future<bool> getVideo(context, String? iddoc, String? title, String? desc) async{

    titleVideo.value=title!;
    descVideo.value=desc!;
    update();

    print('===>>> getVideo <<<=== ${iddoc}');

    // return true;

    showLoadingDialog();
    Json json = Json(
        modelo: 'NOTIFICACIONES',
        metodo: 'GET_VIDEO',
        parametros: { 'IDDOC':'${iddoc}' }
    );

    ResponseApi res = await jsonProvider.json(json);

    var result = res.result!.recordsets[0][0];
    print('=>>> ${result}');
    Map<String, dynamic> readDocs =
    {
      'Tabla':'DOCS',
      'NumPagina':1,
      'TamPagina':1,
      'CondicionAdicional':"DocumentoID='${iddoc}'",
      'DocExtension':'${result['DocExtension']}',
      'DocNombre':'${result['DocNombre']}',
      'DocumentoID':'${iddoc}',
    };

    dynamic resp = await jsonProvider.readDocs(readDocs);

    hideLoadingDialog();
    if(resp['res'] == 'ok'){
      print('RESP=> ${resp['result']}');
      urlVideo.value = 'http://5.161.183.200:82/${resp['result']['sourcePath']}';
      print('urlVideo ${urlVideo.value}');
      return true;
      showVideo(context, urlVideo.value);
    }
    return false;
  }

  void showVideo (context, String? url) {
    late VideoPlayerController urlVideo;
    urlVideo = VideoPlayerController.network('http://5.161.183.200:82/docs/0DA29342-FC20-4405-A5C2-CFD24F629B11.mp4')
    ..initialize().then((_) {
    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      super.refresh();
    });

    print('urlVideo => ${urlVideo.value.aspectRatio}');
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          contentPadding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          // title:
          // Container(
          //     margin: EdgeInsets.only(bottom: 20),
          //     child:
          //     const Text('Confirmación',
          //         style: TextStyle(
          //           fontSize: 22,
          //           color: Color(0xFF243588),
          //           fontFamily: 'AvenirBold',
          //         )
          //     )
          // ),
          children: [
            Column(
              children: [
                Text('${url}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'AvenirReg'
                  ),
                ),
                true //urlVideo.value.isInitialized
                  ? AspectRatio(aspectRatio: urlVideo.value.aspectRatio, child: VideoPlayer(urlVideo),
                  ) : Container(child: Text('No mostrar ${urlVideo}')),
                Container(
                    child: VideoProgressIndicator(
                        urlVideo,
                        allowScrubbing: true,
                        colors:VideoProgressColors(
                          backgroundColor: Colors.redAccent,
                          playedColor: Colors.green,
                          bufferedColor: Colors.purple,
                        )
                    )
                ),
                Text('info ${urlVideo}'),
                Container( //duration of video
                  child: Text("Total Duration: " + urlVideo.value.duration.toString()),
                ),
                FloatingActionButton(
                  onPressed: () {
                    urlVideo.value.isPlaying ? urlVideo.pause() : urlVideo.play();
                    super.refresh();
                  },
                  backgroundColor: Colors.greenAccent,
                  child: Icon(
                    urlVideo.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              shadowColor: Colors.transparent
                          ),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontFamily: 'AvenirReg',
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  void updates(){
    super.refresh();
  }
  void disposes(){
    super.dispose();
  }

  void changeTab(context, int? tab){
    print('contexto => ${context}');
    DefaultTabController.of(context)?.animateTo(1);
    updates();
  }



  NotificationsController(){
    print('Notifications Controller -> User -> : ${user.toJson()}');
  }
}