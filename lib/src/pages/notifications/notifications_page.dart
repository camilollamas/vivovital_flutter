import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/notifications/notifications_controller.dart';
import 'package:vivovital_app/src/utils/drawer_menu.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsController con = Get.put(NotificationsController());
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFFFFFFFF),
            size: 30,
          ),
          onPressed: () => {scaffoldKey.currentState?.openDrawer()},
        ),
        title: Text(
            'VivoVital App',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Color(0xFFFFFFFF),
              fontFamily: 'AvenirReg',
            )
        ),
      ),
      body: Center(
          child: Text('Notifications Page')
      ),
      key: scaffoldKey,
      drawer: Drawer(
        child: _drawerList(),
      ),

    );
  }

  Widget _drawerList(){
    return CustomDrawerMenu();
  }

}
