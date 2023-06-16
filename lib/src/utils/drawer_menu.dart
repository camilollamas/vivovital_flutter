import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivovital_app/src/utils/utils_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vivovital_app/src/models/user.dart';
import 'package:vivovital_app/src/models/admision.dart';

class CustomDrawerMenu extends StatelessWidget {
  UtilController con = Get.put(UtilController());

  User user = User.fromJson(GetStorage().read('user') ?? {});
  Admision admision = Admision.fromJson(GetStorage().read('admision') ?? {});


  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        '${user.pnombre! ?? ''} ${user.snombre! ?? ''} '
        '${user.papellido! ?? ''} ${user.sapellido! ?? ''} ',
      ),
      accountEmail: Text(
        '${user.email! ?? ''}\n'
        '${admision.id ?? ''} ${admision.programaid ?? 'Sin programa.'} ',
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: user.genero == 'Masculino'
            ? AssetImage('assets/img/avatars/male.png') as ImageProvider
            : AssetImage('assets/img/avatars/female.png') as ImageProvider,
        //child: FlutterLogo(size: 42.0),
      ),
    );

    return ListView(
        padding: EdgeInsets.zero,
        children:[
          drawerHeader,
          Container(
            color: '/home' == route?.settings.name
                ? Color(0xFF243588)
                : Colors.white,
            child: ListTile(
              iconColor: '/home' == route?.settings.name
                  ? Colors.white : Color(0xFF243588),
              title: Text(
                'Inicio',
                style: TextStyle(
                  fontSize: 20,
                  color: '/home' == route?.settings.name
                      ? Colors.white :Color(0xFF243588),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
              leading: Icon(
                Icons.home,
                size: 30,
              ),
              onTap: () => con.goToRoute('home'),
            ),
          ),
          Container(
            color: '/profile' == route?.settings.name
                ? Color(0xFF243588)
                : Colors.white,
            child: ListTile(
              iconColor: '/profile' == route?.settings.name
              ? Colors.white : Color(0xFF243588),
              title: Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 20,
                  color: '/profile' == route?.settings.name
                      ? Colors.white :Color(0xFF243588),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
              leading: Icon(
                Icons.person,
                // color: Color(0xFF243588),
                size: 30,
              ),
              onTap: () => con.goToRoute('profile'),
            ),
          ),
          Container(
            color: '/monitoring' == route?.settings.name
                ? Color(0xFF243588)
                : Colors.white,
            child: ListTile(
              iconColor: '/monitoring' == route?.settings.name
                  ? Colors.white : Color(0xFF243588),
              title: Text(
                'Seguimiento',
                style: TextStyle(
                  fontSize: 20,
                  color: '/monitoring' == route?.settings.name
                      ? Colors.white :Color(0xFF243588),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
              leading: Icon(
                Icons.query_stats,
                size: 30,
              ),
              onTap: () => con.goToRoute('monitoring'),
            ),
          ),
          Container(
            color: '/dates' == route?.settings.name
                ? Color(0xFF243588)
                : Colors.white,
            child: ListTile(
              iconColor: '/dates' == route?.settings.name
                  ? Colors.white : Color(0xFF243588),
              title: Text(
                'Citas Médicas',
                style: TextStyle(
                  fontSize: 20,
                  color: '/dates' == route?.settings.name
                      ? Colors.white :Color(0xFF243588),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
              leading: Icon(
                Icons.date_range,
                size: 30,
              ),
              onTap: () => con.goToRoute('dates'),
            ),
          ),
          Container(
            color: '/notifications' == route?.settings.name
                ? Color(0xFF243588)
                : Colors.white,
            child: ListTile(
              iconColor: '/notifications' == route?.settings.name
                  ? Colors.white : Color(0xFF243588),
              title: Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 20,
                  color: '/notifications' == route?.settings.name
                      ? Colors.white :Color(0xFF243588),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'AvenirReg',
                ),
              ),
              leading: Icon(
                Icons.notifications_active_outlined,
                size: 30,
              ),
              onTap: () => con.goToRoute('notifications'),
            ),
          ),
          ListTile(
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF243588),
                fontFamily: 'AvenirReg',
              ),
            ),
            leading: Icon(
              Icons.logout,
              color: Color(0xFF243588),
              size: 30,
            ),
            onTap: () => {
              con.LogOut()
            },
          )
        ]
    );
  }

}

