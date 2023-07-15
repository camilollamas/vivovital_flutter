import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const InitializationSettingsAndroid =  AndroidInitializationSettings('app_icon'); 

    // TODO: IOS configuration

    const initializationSettings = InitializationSettings(
      android: InitializationSettingsAndroid,
      // TODO: IOS configuration
    );     

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
      //
    );

  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data
    }) async {

      const androidDetails = AndroidNotificationDetails (
        'channelId',
        'channelName',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high
      );
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        // TODO: IOS configuration
      );
      
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: data
      );

    }
  
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    Get.toNamed('/notifications');
  }

}