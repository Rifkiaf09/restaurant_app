import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/restaurant_api.dart';
import '../../core/models/restaurant_models.dart';
import '../../providers/favorite_provider.dart';
import '../pages/restaurant_detail_page.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key, required this.item, required this.api});
  final RestaurantSummary item;
  final RestaurantApi api;

  @override
  Widget build(BuildContext context) {
    final tagImg = '${item.id}_img';
    final tagTitle = '${item.id}_title';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
            context, RestaurantDetailPage.routeName,
            arguments: item.id),
        child: Row(
          children: [
            Hero(
                tag: tagImg,
                child: Image.network(api.smallImageUrl(item.pictureId),
                    width: 100, height: 100, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                          tag: tagTitle,
                          child: Material(
                              type: MaterialType.transparency,
                              child: Text(item.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis))),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(item.city)
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(item.rating.toString())
                      ]),
                    ]),
              ),
            ),
            // Favorite icon
            Consumer<FavoriteProvider>(builder: (_, fav, __) {
              return FutureBuilder<bool>(
                future: fav.isFavorite(item.id),
                builder: (_, snap) {
                  final isFav = snap.data ?? false;
                  return IconButton(
                    tooltip: isFav ? 'Hapus favorit' : 'Tambahkan favorit',
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : null),
                    onPressed: () async {
                      if (isFav) {
                        await fav.removeFavorite(item.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Dihapus dari favorit')));
                      } else {
                        await fav.addFavorite(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ditambahkan ke favorit')));
                      }
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
