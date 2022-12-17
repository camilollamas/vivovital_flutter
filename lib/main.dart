import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivovital_app/src/pages/login/login_page.dart';
import 'package:vivovital_app/src/pages/register/register_page.dart';

void main() {
  runApp(const MyApp());
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


    return GetMaterialApp(
      title: 'Vivo Vital App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage() ),
        GetPage(name: '/register', page: () => RegisterPage() )
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
