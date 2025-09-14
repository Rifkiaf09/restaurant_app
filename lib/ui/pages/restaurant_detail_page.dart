import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/restaurant_api.dart';
import '../../core/models/restaurant_models.dart';
import '../../core/state/result_state.dart';
import '../../providers/restaurant_detail_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/detail';
  const RestaurantDetailPage({super.key, required this.id});
  final String id;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final _nameCtrl = TextEditingController();
  final _reviewCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<RestaurantApi>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Restoran')),
      body: Consumer<RestaurantDetailProvider>(
        builder: (_, provider, __) {
          final st = provider.state;
          return switch (st) {
            Loading() => const LoadingView(),
            Error(message: var msg) => ErrorView(
                message: msg,
                onRetry: () => provider.fetchDetail(widget.id),
              ),
            Success(data: var detail) => _DetailView(
                api: api,
                detail: detail,
                nameCtrl: _nameCtrl,
                reviewCtrl: _reviewCtrl,
                posting: provider.posting,
                onSubmit: () async {
                  final name = _nameCtrl.text.trim();
                  final review = _reviewCtrl.text.trim();
                  if (name.isEmpty || review.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Nama dan ulasan wajib diisi')),
                    );
                    return;
                  }
                  await provider.addReview(widget.id, name, review);
                  if (!context.mounted) return;
                  if (provider.state is Error) {
                    final msg = (provider.state as Error).message;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  } else {
                    _nameCtrl.clear();
                    _reviewCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ulasan terkirim')),
                    );
                  }
                },
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({
    required this.api,
    required this.detail,
    required this.nameCtrl,
    required this.reviewCtrl,
    required this.onSubmit,
    required this.posting,
  });

  final RestaurantApi api;
  final RestaurantDetail detail;
  final TextEditingController nameCtrl;
  final TextEditingController reviewCtrl;
  final Future<void> Function() onSubmit;
  final bool posting;

  @override
  Widget build(BuildContext context) {
    final tagImg = '${detail.id}_img';
    final tagTitle = '${detail.id}_title';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: tagImg,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  api.mediumImageUrl(detail.pictureId),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Hero(
            tag: tagTitle,
            child: Material(
              type: MaterialType.transparency,
              child: Text(detail.name,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 4),
            Text('${detail.city} • ${detail.address}'),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(detail.rating.toString()),
          ]),
          const SizedBox(height: 12),
          Text(detail.description),
          const SizedBox(height: 16),
          Text('Menu', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _menuRow('Makanan', detail.menus.foods.map((e) => e.name).toList()),
          const SizedBox(height: 8),
          _menuRow('Minuman', detail.menus.drinks.map((e) => e.name).toList()),
          const SizedBox(height: 16),
          Text('Ulasan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _reviews(detail.customerReviews),
          const SizedBox(height: 16),
          Text('Tulis Ulasan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Anda'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: reviewCtrl,
                decoration: const InputDecoration(labelText: 'Ulasan'),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: posting ? null : onSubmit,
              icon: posting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Kirim'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuRow(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map((e) => SizedBox(
                      width: 140,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.fastfood),
                              const SizedBox(height: 8),
                              Text(e,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _reviews(List<CustomerReview> list) {
    if (list.isEmpty) return const Text('Belum ada ulasan');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final r = list[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(r.name),
          subtitle: Text(r.review),
          trailing: Text(r.date, style: const TextStyle(fontSize: 12)),
        );
      },
    );
  }
}
