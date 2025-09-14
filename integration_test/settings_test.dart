import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

import 'robot/settings_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Page Tests', () {
    testWidgets(
      'toggle dark theme and daily reminder, then test notification',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // buka halaman settings
        // karena di main.dart route sudah ada, langsung aje pakai:
        await tester.tap(
          find.byTooltip('Open navigation menu').evaluate().isNotEmpty
              ? find.byTooltip('Open navigation menu')
              : find.byIcon(Icons.more_vert),
        );
        await tester.pumpAndSettle();

        // kalau tidak ada drawer/menu, langsung navigate
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        final robot = SettingsRobot(tester);

        // pastikan halaman ditemukan
        robot.expectPageFound();

        // toggle dark theme
        await robot.toggleDarkTheme();

        // toggle daily reminder
        await robot.toggleDailyReminder();

        // tekan tombol uji notifikasi
        await robot.pressTestNotification();
      },
    );
  });
}
