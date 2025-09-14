import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import '../../core/api/restaurant_api.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/loading_view.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  static const routeName = '/favorites';

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FavoriteProvider>().loadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<RestaurantApi>();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: Consumer<FavoriteProvider>(builder: (_, fav, __) {
        if (fav.loading) return const LoadingView();
        if (fav.favorites.isEmpty) {
          return const Center(child: Text('Belum ada favorit'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: fav.favorites.length,
          itemBuilder: (_, i) =>
              RestaurantCard(item: fav.favorites[i], api: api),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
        );
      }),
    );
  }
}
