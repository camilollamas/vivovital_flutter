import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../firebase_options.dart';
import '../../../domain/entities/push_message.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}


class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  NotificationsBloc() : super( const NotificationsState() ) {

    on<NotifiactionsStatusChange>( _notificationsStatusChanged );

    _initialStatusCheck(); //Verificar estado de las notificaciones
    _onforegroundMessage(); //Listener para cuando la app esta en primer plano
    // requestPermission();

  }

  static Future<void> initializeFirebaseNotifications() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged(NotifiactionsStatusChange event, Emitter<NotificationsState> emit){
    emit( state.copyWith(status: event.status) );
    _getFCMToken();
  }

  void _initialStatusCheck () async {
    final settings = await messaging.getNotificationSettings();
    add( NotifiactionsStatusChange(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    final settings = await messaging.getNotificationSettings();

    if( settings.authorizationStatus != AuthorizationStatus.authorized ) return;

    final token = await messaging.getToken();
    print('Token: $token');
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null)return; 

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),

      data: message.data,
      imageUrl: Platform.isAndroid ? message.notification!.android!.imageUrl : message.notification!.apple!.imageUrl

    );

    print('Message also contained a notification: ${notification.toString()}');

  }

  void _onforegroundMessage (){
    FirebaseMessaging.onMessage.listen( handleRemoteMessage ); 
  }

  void requestPermission() async {

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );
    add( NotifiactionsStatusChange(settings.authorizationStatus));
  }

  PushMessage? getMessageById (String pushMessageId){
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if (!exist) return null;
    
    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }


}