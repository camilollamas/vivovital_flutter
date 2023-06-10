import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/monitoring/monitoring_controller.dart';
import 'package:vivovital_app/src/utils/drawer_menu.dart';

class MonitoringPage extends StatelessWidget {
  MonitoringController con = Get.put(MonitoringController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonitoringController>(
      init: con,
      initState: (_) {
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
              Scaffold(
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
                  title: const Text('VivoVital App',
                      style: TextStyle( fontSize: 30, fontWeight:
                                FontWeight.w300,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'AvenirReg',
                            )
                        ),
                ),
                body: Stack(
                    children:[
                      _boxSeguimiento(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buttonBack(),
                          _textTitlePage(),
                        ],
                      ),
                    ]
                  ),
                key: scaffoldKey,
                drawer: Drawer(
                  child: _drawerList(),
                ),
              )
            ]
          );
      }
    );
  }


  Widget _boxSeguimiento(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height * 2.0,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, left: 00, right: 0, bottom: 0 ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textTitleLabs(),
            _textdescLabs(),
            _btnDownloadFile(),
            // _fistName(),
           
          ]
        )
      )
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
    return const Text(
        'Seguimiento',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Color(0xFF243588),
          fontFamily: 'AvenirReg',
        )
    );
  }


  //Widget do download file pdf
  Widget _textTitleLabs(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: const Text(
              'Exámenes de laboratorio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirBold',
              )
            ),
          )
        ],
      ),
    );
  }
  Widget _textdescLabs(){
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0, left: 30, right: 5),
            alignment: Alignment.center,
            child: const Text(
              'Los resultados de los exámenes deben tener una vigencia inferior a 30 días hábiles y deben estar en formato PDF',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              )
            ),
          )
        ],
      ),
    );
  }
  Widget _btnDownloadFile(){
    return Container(
      margin: EdgeInsets.only(top: 10, left: 5, right: 0, bottom: 15 ),
        child: FloatingActionButton.extended(
          onPressed: () { con.genPDfLabs(); },
          backgroundColor: Color(0xFF243588),
          icon: Icon(Icons.download, color: Colors.white),
          label: Text(
              'Descargar Orden en PDF',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontFamily: 'AvenirReg',
              )
          ),
        )
    );
  }

  Widget _drawerList(){
    return CustomDrawerMenu();
  }

}
