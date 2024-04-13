import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:vitalhelp_app/src/models/user.dart';
import 'package:vitalhelp_app/src/pages/dates/dates_page.dart';
import 'package:vitalhelp_app/src/pages/login/login_page.dart';
import 'package:vitalhelp_app/src/pages/monitoring/monitoring_page.dart';
import 'package:vitalhelp_app/src/pages/notifications/notifications_page.dart';
import 'package:vitalhelp_app/src/pages/profile/profile_page.dart';
import 'package:vitalhelp_app/src/pages/profile/update/update_profile_page.dart';
import 'package:vitalhelp_app/src/pages/register/register_page.dart';
import 'package:vitalhelp_app/src/pages/rememberPassword/remember_page.dart';
import 'package:vitalhelp_app/src/pages/home/home_page.dart';
import 'package:vitalhelp_app/src/pages/paid/paid_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vitalhelp_app/src/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:vitalhelp_app/src/utils/local_notifications.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFirebaseNotifications();

  await LocalNotifications.initializeLocalNotifications();
  
  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc())
        ], 
      child: LoadingProvider(
                themeData: LoadingThemeData(),
                child: const MyApp()
            )
      )
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
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: const [
         Locale('es'),
         Locale('en')
       ],
      title: 'Vital Help App',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.idafiliado != null  ? '/home' :  '/',
      getPages: [
        GetPage(name: '/', page: () => const LoginPage() ),
        GetPage(name: '/register', page: () => const RegisterPage() ),
        GetPage(name: '/remember', page: () => RememberPage() ),
        GetPage(name: '/home', page: () => HomePage() ),
        GetPage(name: '/profile', page: () => ProfilePage() ),
        GetPage(name: '/update_profile', page: () => UpdateProfilePage() ),
        GetPage(name: '/monitoring', page: () => MonitoringPage() ),
        GetPage(name: '/notifications', page: () => const NotificationsPage() ),
        GetPage(name: '/dates', page: () => const DatesPage() ),
        GetPage(name: '/paid', page: () => PaidPage() )
      ],
      theme: ThemeData(
        primaryColor:const Color(0xff243588),
        colorScheme: const ColorScheme(
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
      builder: (context, child) {
        return HandleNotificationInteractions(child: child!);
      },
    );
  }
}


class HandleNotificationInteractions extends StatefulWidget {

  final Widget child;
  const HandleNotificationInteractions({Key? key, required this.child});
  // const HandleNotificationInteractions({super.key, Key? key, required this.child});

  @override
  _HandleNotificationInteractionsState createState() => _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions> {
  get appRouter => null;

   // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    print('======================>>>>> Handling a background message: ${message.messageId}');
    
    context.read<NotificationsBloc>()
    .handleRemoteMessage(message);

    // appRouter.push('/notifications');
    Get.toNamed('/notifications');

    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat', 
    //     arguments: ChatArguments(message),
    //   );
    // }
  }
  
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}