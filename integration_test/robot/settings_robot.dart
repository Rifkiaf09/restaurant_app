import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class SettingsRobot {
  final WidgetTester tester;
  SettingsRobot(this.tester);

  /// Pastikan halaman pengaturan terbuka
  void expectPageFound() {
    expect(find.text('Pengaturan'), findsOneWidget);
  }

  /// Toggle tema gelap
  Future<void> toggleDarkTheme() async {
    final switchFinder = find.byKey(const Key('darkThemeSwitch'));
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  }

  /// Toggle daily reminder
  Future<void> toggleDailyReminder() async {
    final switchFinder = find.byKey(const Key('dailyReminderSwitch'));
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  }

  /// Tekan tombol uji notifikasi
  Future<void> pressTestNotification() async {
    final buttonFinder = find.byKey(const Key('testNotificationButton'));
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
  }

  /// Opsional: cek status switch tema gelap
  Future<void> expectDarkThemeIs(bool expected) async {
    final switchWidget = tester.widget<Switch>(
      find.byKey(const Key('darkThemeSwitch')),
    );
    expect(switchWidget.value, expected);
  }

  /// Opsional: cek status daily reminder
  Future<void> expectDailyReminderIs(bool expected) async {
    final switchWidget = tester.widget<Switch>(
      find.byKey(const Key('dailyReminderSwitch')),
    );
    expect(switchWidget.value, expected);
  }
}
