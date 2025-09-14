import 'dart:math';
import 'package:workmanager/workmanager.dart';
import '../core/api/restaurant_api.dart';
import 'notification_service.dart';

const fetchBackground = 'fetch_background';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationService.init();
      final api = RestaurantApi();
      final list = await api.fetchList();
      if (list.isNotEmpty) {
        final r = list[Random().nextInt(list.length)];
        await NotificationService.show(
            'Rekomendasi Hari Ini', '${r.name} — ${r.city}');
      }
    } catch (_) {
      // silently fail
    }
    return Future.value(true);
  });
}
