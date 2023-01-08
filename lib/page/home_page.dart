import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cat_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _ListView(),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(totalCatCountProvider);
    return asyncData.when(
      data: (totalCount) {
        return ListView.builder(
          itemCount: totalCount,
          itemBuilder: (_, index) {
            return ProviderScope(
              overrides: [listIndexProvider.overrideWith((_) => index)],
              child: const _ListItem(),
            );
          },
        );
      },
      error: (_, __) => const Center(child: Text('err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ListItem extends ConsumerWidget {
  const _ListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.read(listIndexProvider);
    final asyncData = ref.watch(catAtIndexProvider(index));
    return asyncData.when(
      data: (cat) => Card(child: ListTile(title: Text(cat.fact))),
      error: (_, __) => const Center(child: Text('err')),
      loading: () => const Card(child: ListTile()),
    );
  }
}
