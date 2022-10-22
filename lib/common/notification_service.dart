import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sale_soft/common/notification_bloc.dart';

class NotificationService {
  /// We want singelton object of ``NotificationService`` so create private constructor
  /// Use NotificationService as ``NotificationService.instance``
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// For local_notification id
  int _count = 0;

  /// ``NotificationService`` started or not.
  /// to start ``NotificationService`` call start method
  bool _started = false;

  /// Call this method on startup
  /// This method will initialise notification settings
  void start() {
    if (!_started) {
      _integrateNotification();
      _refreshToken();
      _started = true;
    }
  }

  // Call this method to initialize notification

  void _integrateNotification() {
    _registerNotification();
    _initializeLocalNotification();
  }

  /// initialize firebase_messaging plugin
  void _registerNotification() {
    _firebaseMessaging.requestPermission();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    // });

    _firebaseMessaging.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);
  }

  /// Token is unique identity of the device.
  /// Token is required when you want to send notification to perticular user.
  void _refreshToken() {
    _firebaseMessaging.getToken().then((token) async {
      print('token: $token');
    }, onError: _tokenRefreshFailure);
  }

  /// This method will be called device token get refreshed
  void _tokenRefresh(String newToken) async {
    print('New Token : $newToken');
  }

  void _tokenRefreshFailure(error) {
    print("FCM token refresh failed with error $error");
  }

  /// This method will be called on tap of the notification which came when app was in foreground
  ///
  /// Firebase messaging does not push notification in notification panel when app is in foreground.
  /// To send the notification when app is in foreground we will use flutter_local_notification
  /// to send notification which will behave similar to firebase notification
  Future<void> _onMessage(Map<String, dynamic> message) async {
    print('onMessage: $message');
    if (Platform.isIOS) {
      // message = _modifyNotificationJson(message);
    }
    _showNotification(
      {
        "title": message['notification']['title'],
        "body": message['notification']['body'],
        "data": message['data'],
      },
    );
  }

  /// This method will be called on tap of the notification which came when app was closed
  Future<void>? _onLaunch(Map<String, dynamic> message) {
    print('onLaunch: $message');
    if (Platform.isIOS) {
      // message = _modifyNotificationJson(message);
    }
    _performActionOnNotification(message);
    return null;
  }

  /// This method will be called on tap of the notification which came when app was in background
  Future<void>? _onResume(Map<String, dynamic> message) {
    print('onResume: $message');
    if (Platform.isIOS) {
      // message = _modifyNotificationJson(message);
    }
    _performActionOnNotification(message);
    return null;
  }

  /// This method will modify the message format of iOS Notification Data
  Map _modifyNotificationJson(Map<String, dynamic> message) {
    message['data'] = Map.from(message);
    message['notification'] = message['aps']['alert'];
    return message;
  }

  /// We want to perform same action of the click of the notification. So this common method will be called on
  /// tap of any notification (onLaunch / onMessage / onResume)
  void _performActionOnNotification(Map<String, dynamic> message) {
    NotificationsBloc.instance.newNotification(message);
  }

  /// used for sending push notification when app is in foreground
  void _showNotification(message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      ++_count,
      message['title'],
      message['body'],
      platformChannelSpecifics,
      payload: json.encode(
        message['data'],
      ),
    );
  }

  /// initialize flutter_local_notification plugin
  void _initializeLocalNotification() async {
    var iosInitializationSettings = new IOSInitializationSettings();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print("Receive local");
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }

    /// Push controller
  }
}
