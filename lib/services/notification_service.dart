import 'dart:math';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/api/restaurant_api.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void fetchBackground() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Init notifikasi ulang (karena ini berjalan di background isolate)
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: androidInit, iOS: iosInit),
      );

      // Panggil API
      final api = RestaurantApi();
      final list = await api.fetchList();
      if (list.isNotEmpty) {
        final randomRestaurant = list[Random().nextInt(list.length)];

        const androidDetails = AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          channelDescription: 'Pengingat makan siang',
          importance: Importance.max,
          priority: Priority.high,
        );

        const iosDetails = DarwinNotificationDetails();

        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          'Saatnya makan siang!',
          'Coba kunjungi ${randomRestaurant.name} di ${randomRestaurant.city}',
          notificationDetails,
        );
      }
    } catch (e) {
      // Bisa tambahkan debugPrint atau log
    }
    return Future.value(true);
  });
}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
  }

  static Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminder',
      channelDescription: 'Pengingat makan siang',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
