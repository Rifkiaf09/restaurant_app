import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/restaurant_api.dart';
import '../../services/notification_service.dart';
import '../../providers/theme_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.read<ThemeProvider>();
    // use watch for live updates
    final settingsProv = context.watch<SettingsProvider>();
    final api = context.read<RestaurantApi>();

    final isDark = themeProv.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: const Text('Tema Gelap'),
              subtitle: const Text('Gunakan tema gelap pada seluruh aplikasi'),
              trailing: Switch.adaptive(
                key: const Key('darkThemeSwitch'), // 🔑
                value: isDark,
                onChanged: (v) async {
                  // set theme explicitly by toggling only when necessary
                  if (v && themeProv.mode != ThemeMode.dark) {
                    themeProv.toggle();
                  } else if (!v && themeProv.mode != ThemeMode.light) {
                    themeProv.toggle();
                  }
                  // persist preference
                  await context.read<SettingsProvider>().setDark(v);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Daily Reminder'),
              subtitle: const Text(
                'Terima notifikasi rekomendasi restoran setiap hari jam 11:00',
              ),
              trailing: Switch.adaptive(
                key: const Key('dailyReminderSwitch'), // 🔑
                value: settingsProv.dailyReminder,
                onChanged: (v) async {
                  await context.read<SettingsProvider>().setDailyReminder(v);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Uji Notifikasi'),
              subtitle: const Text(
                'Kirim notifikasi rekomendasi restoran sekarang (test)',
              ),
              trailing: FilledButton(
                key: const Key('testNotificationButton'), // 🔑
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    final list = await api.fetchList();
                    if (list.isEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Daftar restoran kosong')),
                      );
                      return;
                    }
                    final r = list[Random().nextInt(list.length)];
                    await NotificationService.show(
                      'Rekomendasi Hari Ini',
                      '${r.name} — ${r.city}',
                    );
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Notifikasi terkirim')),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengirim notifikasi'),
                      ),
                    );
                  }
                },
                child: const Text('Kirim Sekarang'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Tentang'),
              subtitle: const Text('Versi aplikasi dan informasi pengembang'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Restaurant App',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
