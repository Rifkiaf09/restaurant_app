import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

import 'robot/settings_robot.dart';
import 'robot/favorites_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test', () {
    testWidgets('Buka Settings dan ubah tema', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final settingsRobot = SettingsRobot(tester);

      // pastikan halaman settings ditemukan
      settingsRobot.expectPageFound();

      // toggle dark mode
      await settingsRobot.toggleDarkTheme();

      // toggle daily reminder
      await settingsRobot.toggleDailyReminder();

      // tekan tombol test notifikasi
      await settingsRobot.pressTestNotification();
    });

    testWidgets('Buka halaman Favorit', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final favRobot = FavoritesRobot(tester);

      // pastikan halaman favorit ditemukan
      favRobot.expectPageFound();
    });
  });
}
