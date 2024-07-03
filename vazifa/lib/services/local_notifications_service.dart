import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationsEnable = false;

  static Future<void> requestPermission() async {
    // Qanday qurilmada run bo'layotganini tekshirish
    if (Platform.isIOS || Platform.isMacOS) {
      // Ios ga ruxsat olish
      notificationsEnable = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;

      //MacOs
      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      //Android
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // 1ta xabar uchun
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      // rejali xabar uchun
      final bool? grantedSchedueledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      // ruxsat berilganini bilish uchun
      notificationsEnable = grantedNotificationPermission ?? false;
      notificationsEnable = grantedSchedueledNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    // hozirgi joylashuv (timezone) bilan vaqtni oladi
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // android va IOS uchun sozlamalarni to'g'irlaymiz
    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );

    // umumiy sozlamalarga e'lon qilaman
    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    // va FlutterLocalNotification klasiga sozlamalarni yuboraman
    // u esa kerakli qurilma sozlamalarini to'g'irlaydi
    await _localNotification.initialize(notificationInit);
  }

  static void showNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      actions: [
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.mp3",
      categoryIdentifier: "demoCategory",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.show(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      notificationDetails,
    );
  }

  static void showScheduledNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.zonedSchedule(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Salom",
    );
  }

  static void showPeriodicNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.periodicallyShow(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: "Salom",
    );
  }

  static void showDailyAt8AMNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 38);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _localNotification.zonedSchedule(
      0,
      "Har kuni soat 08:00 da",
      "Bu har kunlik 08:00 bildirishnoma",
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "Har kuni soat 08:00 da",
    );
  }
}
