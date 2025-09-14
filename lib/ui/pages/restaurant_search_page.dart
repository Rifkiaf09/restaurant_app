import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/restaurant_api.dart';
import '../../core/state/result_state.dart';
import '../../providers/restaurant_search_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/restaurant_card.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/search';
  const RestaurantSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<RestaurantApi>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Restoran')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Ketik kata kunci...',
              ),
              onChanged: (q) =>
                  context.read<RestaurantSearchProvider>().search(q),
            ),
          ),
          Expanded(
            child: Consumer<RestaurantSearchProvider>(
              builder: (_, provider, __) {
                final st = provider.state;
                return switch (st) {
                  Loading() => const LoadingView(),
                  Error(message: var msg) => ErrorView(message: msg),
                  Empty() => const Center(
                      child: Text('Ketik untuk mencari restoran.'),
                    ),
                  Success(data: var items) => ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (_, i) =>
                          RestaurantCard(item: items[i], api: api),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: items.length,
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
