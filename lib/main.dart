import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vivovital_app/src/models/user.dart';
import 'package:vivovital_app/src/pages/dates/dates_page.dart';
import 'package:vivovital_app/src/pages/login/login_page.dart';
import 'package:vivovital_app/src/pages/monitoring/monitoring_page.dart';
import 'package:vivovital_app/src/pages/notifications/notifications_page.dart';
import 'package:vivovital_app/src/pages/profile/profile_page.dart';
import 'package:vivovital_app/src/pages/profile/update/update_profile_page.dart';
import 'package:vivovital_app/src/pages/register/register_page.dart';
import 'package:vivovital_app/src/pages/home/home_page.dart';
import 'package:vivovital_app/src/pages/paid/paid_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  await GetStorage.init();
  runApp(
    LoadingProvider(
        child: const MyApp(),
        themeData: LoadingThemeData())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    //Cosntruye las vistas de la app
    print('Afiliado: ${userSession.idafiliado}');

    return GetMaterialApp(
      title: 'Vivo Vital App',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.idafiliado != null  ? '/home' :  '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage() ),
        GetPage(name: '/register', page: () => RegisterPage() ),
        GetPage(name: '/home', page: () => HomePage() ),
        GetPage(name: '/profile', page: () => ProfilePage() ),
        GetPage(name: '/update_profile', page: () => UpdateProfilePage() ),
        GetPage(name: '/monitoring', page: () => MonitoringPage() ),
        GetPage(name: '/notifications', page: () => NotificationsPage() ),
        GetPage(name: '/dates', page: () => DatesPage() ),
        GetPage(name: '/paid', page: () => PaidPage() )
      ],
      theme: ThemeData(
        primaryColor: Color(0xff243588),
        colorScheme: ColorScheme(
            primary: Color(0xff243588),
            secondary: Color(0xff72246c),
            error: Color(0xffC10015),
            brightness: Brightness.light,
            onPrimary: Color(0xff243588),
            onSecondary: Color(0xff72246c),
            onError: Colors.grey,
            background: Colors.grey,
            onBackground: Colors.grey,
            surface: Colors.grey,
            onSurface: Colors.grey

        )
      ),
      navigatorKey: Get.key,
    );
  }
}
