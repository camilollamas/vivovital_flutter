import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:vitalhelp_app/src/pages/notifications/notifications_controller.dart';
import 'package:vitalhelp_app/src/utils/drawer_menu.dart';
import 'package:intl/intl.dart';

import '../../models/alerta.dart';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

String longVideo = "http://192.168.1.11:90/docs/0DA29342-FC20-4405-A5C2-CFD24F629B11.mp4"; //con.urlVideo.value!;

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}
class NotificationsPageState extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
  with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  NotificationsController con = Get.put(NotificationsController());




  var scaffoldKey = GlobalKey<ScaffoldState>();

// ==============================
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings();

  final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
  CustomVideoPlayerWebSettings(
    src: longVideo,
  );

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
  }

// ====================== 75BD18E8-75B6-48CC-84F2-CA1F240F274A.mp4
  @override
  Widget build(BuildContext context) {
   //..initialize().then((value) => con.updates());
    return GetBuilder<NotificationsController>(
        init: con,
        initState: (_) {
          _videoPlayerController = VideoPlayerController.network(longVideo);
          // _customVideoPlayerController = CustomVideoPlayerController(
          //   context: context,
          //   videoPlayerController: _videoPlayerController,
          //   customVideoPlayerSettings: _customVideoPlayerSettings,
          //   additionalVideoSources: { "720p": _videoPlayerController },
          // );

          _customVideoPlayerWebController = CustomVideoPlayerWebController(
            webVideoPlayerSettings: _customVideoPlayerWebSettings,
          );

          con.getDay();
        },
        builder: (_) {
          return
            Stack(
                children: [
                  _imageBgWhite(),
                  Positioned.fill(
                      child:
                      _imageBg(context)
                  ),
                  _bgDegrade(context),
                  DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                          onPressed: () => {scaffoldKey.currentState?.openDrawer()},
                        ),
                        title: const Text(
                            'vitalhelp App',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'AvenirReg',
                            )
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          Stack(
                            children:[
                              Container(
                                  height: MediaQuery.of(context).size.height * 2.0,
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 0, right: 0, bottom: 0),
                                    child: Column(
                                      children: [
                                        _listView()
                                      ]
                                  )
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buttonBack(),
                                      _textTitlePage(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _TextDate(),
                                    ],
                                  ),
                                  _divider()
                                ],
                              ),
                            ]
                          ),
                          Stack(
                            children: [
                              CupertinoPageScaffold(
                                child: SafeArea(
                                  child: ListView(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: IconButton(
                                                onPressed: () => {
                                                  setState(() {
                                                  _videoPlayerController.pause();
                                                  // _videoPlayerController.dispose(),
                                                    _tabController.index = 0;
                                                  }),

                                                },
                                                icon: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Color(0xFF243588),
                                                  size: 20,
                                                ),
                                              )
                                          ),
                                          Text('${con.titleVideo.value ?? ''}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFF243588),
                                                fontFamily: 'AvenirReg',
                                              ),
                                          ),

                                        ],
                                      ),
                                      // Text('${_videoPlayerController}'),

                                      // kIsWeb ? Expanded(
                                      //   child: CustomVideoPlayerWeb(
                                      //           customVideoPlayerWebController:
                                      //           _customVideoPlayerWebController,
                                      //         ),
                                      //   )
                                      _videoPlayerController.value.isInitialized ? CustomVideoPlayer(
                                          customVideoPlayerController: _customVideoPlayerController )
                                      : Container(),
                                      // CustomVideoPlayer(
                                      //     customVideoPlayerController: _customVideoPlayerController ,
                                      //   ),
                                      // CustomVideoPlayer(
                                      //     customVideoPlayerController: _customVideoPlayerController
                                      // ),
                                      CupertinoButton(
                                        child: _videoPlayerController.value.isInitialized ? const Text("Ver en pantalla completa") : Container(),
                                          onPressed: () {
                                            if (kIsWeb) {
                                              _customVideoPlayerWebController.setFullscreen(true);
                                              _customVideoPlayerWebController.play();
                                            } else {
                                              _customVideoPlayerController.setFullscreen(true);
                                              _customVideoPlayerController.videoPlayerController.play();
                                            }
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      key: scaffoldKey,
                      drawer: Drawer(
                        child: _drawerList(),
                      ),
                    ),
                  )
                ]
            );
        }
    );
  }

  void setVideoController(String? urlVideo){
    // print('${_videoPlayerController}'),
    // Future.delayed(const Duration(seconds: 4), () {
    setState(() {
        _videoPlayerController = VideoPlayerController.network(
          "http://192.168.1.11:90/docs/${urlVideo}.mp4",
        )..initialize().then((value) => con.updates());

        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoPlayerController,
          customVideoPlayerSettings: _customVideoPlayerSettings,
          additionalVideoSources: { "720p": _videoPlayerController },
        );
        _customVideoPlayerWebController = CustomVideoPlayerWebController(
          webVideoPlayerSettings: _customVideoPlayerWebSettings,
        );
    });
      // _videoPlayerController.play();
    // });


  }

  Widget _listView(){
    return FutureBuilder(
        future: con.sendNotify(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return
              Column(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index){
                        print('index => ${index} context => ${context.toString()}');
                        return _NotifyCards(snapshot.data![index], context);
                      }
                  ),
                ],
              );
          }else{
            return Text('Sin Notificaciones');
          }
        }
    );
  }

  Widget _NotifyCards(Alerta alerta, BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: Card(
          color: Color(0xFFc1f4cd),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(
                      color: Color(0xFF21ba45),
                      width: 5
                  )
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Ink(
                                decoration: _colorNotify(alerta.tipo),
                                child: InkWell(
                                  onTap: () {
                                    con.chooseDate();
                                  },
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: _iconNotify(alerta.tipo),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              child:Text('${alerta.titulo ?? ''} ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w300,
                                    color: Color(0xFF243588),
                                    fontFamily: 'AvenirReg',
                                  )
                              ),
                            )
                          ],
                        ),
                        _divider(),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text('${alerta.descripcion ?? ''} ',
                              style: const TextStyle(
                                fontSize: 15,
                                // fontWeight: FontWeight.w300,
                                color: Color(0xFF243588),
                                fontFamily: 'AvenirBold',
                              )
                          ),
                        ),
                        Visibility(
                          visible: alerta.tipo  == 'Video',
                            child: FloatingActionButton.extended(
                                onPressed: () => {
                                  con.getVideo(context,alerta.iddocs, alerta.titulo, alerta.descripcion),
                                  showLoadingDialog(),
                                  setState(() {
                                    setVideoController(alerta.iddocs);
                                    Future.delayed(const Duration(seconds: 3), (){
                                      hideLoadingDialog();
                                      // con.getVideo(context,alerta.iddocs, alerta.titulo, alerta.descripcion);
                                      _tabController.index = 1;
                                      _videoPlayerController.play();

                                    });
                                  })

                                },
                                icon: Icon(Icons.play_arrow, color: Colors.white),
                                backgroundColor: Color(0xFF03a9f4),
                                label: const Text(
                                  'Ver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'AvenirReg',
                                  ),
                                )
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          )
        )
    );
  }

  Decoration _colorNotify(String? type){
    if(type == 'Video' ){
      return BoxDecoration(
          border: Border.all(color: Color(0xFF03a9f4), width: 2),
          color: Color(0xFF03a9f4), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }
    if(type == 'Recordatorio'){
      return BoxDecoration(
          border: Border.all(color: Color(0xFFff9800), width: 2),
          color: Color(0xFFff9800), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }
    if(type == 'Audio'){
      return BoxDecoration(
          border: Border.all(color: Color(0xFF21ba45), width: 2),
          color: Color(0xFF21ba45), //Colors.white,
          borderRadius: BorderRadius.circular(50.0)
      );
    }

    return BoxDecoration(
        border: Border.all(color: Color(0xFFff9800), width: 2),
        color: Color(0xFFff9800), //Colors.white,
        borderRadius: BorderRadius.circular(50.0)
    );
  }

  Widget _iconNotify(String? type){
    if(type == 'Video' ){
      return const Icon(
          Icons.video_camera_front,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }
    if(type == 'Recordatorio'){
      return const Icon(
          Icons.notifications_active,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }
    if(type == 'Audio'){
      return const Icon(
          Icons.headphones,
          size: 20.0,
          color: Colors.white// Color(0xFF243588),
      );
    }

    return const Icon(
        Icons.notifications_active,
        size: 20.0,
        color: Colors.white// Color(0xFF243588),
    );
  }

  Widget _TextDate(){
    return Row(
      children: [
        Text(
          DateFormat("dd-MM-yyyy")
              .format(con.selectedDate.value)
              .toString(),
          style: const TextStyle(
            fontSize: 25,
            // fontWeight: FontWeight.w300,
            color: Color(0xFF243588),
            fontFamily: 'AvenirReg',
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF243588), width: 2),
                color: Color(0xFF243588), //Colors.white,
                borderRadius: BorderRadius.circular(50.0)
              ),
              child: InkWell(
                onTap: () {
                  con.chooseDate();
                  },
                borderRadius: BorderRadius.circular(30.0),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.date_range,
                    size: 20.0,
                    color: Colors.white// Color(0xFF243588),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(){
    return
      Divider(
        color: Colors.black54,
        height: 10,
        thickness: 0,
        indent: 10,
        endIndent: 10,
      );
  }

  Widget _bgDegrade(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                offset: Offset(0, 0)
            )
          ]
      ),
    );
  }

  Widget _imageBg(BuildContext context){
    return  Image.asset(
      'assets/img/background.png',
      fit: BoxFit.cover,
    );
  }

  Widget _imageBgWhite(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () => Get.offNamed('/home'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF243588),
                size: 20,
              ),
            )
        )
    );
  }

  Widget _textTitlePage(){
    return Container(
      child: const Text(
          'Notificaciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Color(0xFF243588),
            fontFamily: 'AvenirReg',
          )
      ),
    );
  }

  Widget _drawerList(){
    return CustomDrawerMenu();
  }
}
