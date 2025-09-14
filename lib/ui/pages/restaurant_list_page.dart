import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/restaurant_list_provider.dart';
import '../../ui/pages/restaurant_search_page.dart';
import '../../ui/pages/favorites_page.dart';
import '../../ui/pages/settings_page.dart';
import '../../ui/widgets/restaurant_card.dart';
import '../../core/models/restaurant_models.dart';
import '../../core/state/result_state.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    // otomatis panggil fetchList ketika halaman pertama kali dibuka
    Future.microtask(() => context.read<RestaurantListProvider>().fetchList());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantListProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, RestaurantSearchPage.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, FavoritesPage.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state is Loading<List<RestaurantSummary>>) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Success<List<RestaurantSummary>>) {
            final list = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<RestaurantListProvider>().fetchList();
              },
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(item: list[index], api: provider.api);
                },
              ),
            );
          } else if (state is Empty<List<RestaurantSummary>>) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<RestaurantListProvider>().fetchList();
              },
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Tidak ada data restoran.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is Error<List<RestaurantSummary>>) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<RestaurantListProvider>().fetchList();
              },
              child: ListView(
                children: [
                  const SizedBox(height: 100),
                  const Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await context
                            .read<RestaurantListProvider>()
                            .fetchList();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
