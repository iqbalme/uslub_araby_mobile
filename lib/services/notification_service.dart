import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Request permissions
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleDailyLearningReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learning_reminder_enabled', enabled);

    if (enabled) {
      await _scheduleNotification(
        id: 1,
        title: 'Waktunya Belajar!',
        body: 'Jangan lupa belajar ungkapan Arab hari ini.',
        hour: 9,
        minute: 0,
      );
    } else {
      await _flutterLocalNotificationsPlugin.cancel(1);
    }
  }

  Future<void> scheduleDailyNewWordReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('new_word_reminder_enabled', enabled);

    if (enabled) {
      await _scheduleNotification(
        id: 2,
        title: 'Kata Baru Menanti!',
        body: 'Ada kata baru untuk dipelajari hari ini.',
        hour: 10,
        minute: 0,
      );
    } else {
      await _flutterLocalNotificationsPlugin.cancel(2);
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'uslub_channel',
        'Uslub Notifications',
        channelDescription: 'Notifikasi untuk aplikasi Kamus Uslub',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<bool> isLearningReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('learning_reminder_enabled') ?? false;
  }

  Future<bool> isNewWordReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('new_word_reminder_enabled') ?? false;
  }
}
