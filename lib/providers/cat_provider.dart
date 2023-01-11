import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cat.dart';

// page size
const limit = 10;

final dioProvider = Provider((_) {
  const baseUrl = 'https://catfact.ninja';
  final options = BaseOptions(baseUrl: baseUrl);
  return Dio(options);
});

final paginatedCatsProvider = FutureProvider.family<PaginatedResponse, int>(
  (ref, page) async {
    final dio = ref.read(dioProvider);
    final params = {'limit': limit, 'page': page + 1};
    final res = await dio.get('/facts', queryParameters: params);
    return PaginatedResponse.fromJson(res.data);
  },
  dependencies: [dioProvider],
);

final totalCatCountProvider = Provider<AsyncValue<int>>(
  (ref) => ref.watch(paginatedCatsProvider(0)).whenData((e) => e.totalCount),
  dependencies: [paginatedCatsProvider],
);

final listIndexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

final catAtIndexProvider = Provider.family<AsyncValue<Cat>, int>(
  (ref, index) {
    final page = index ~/ limit;
    final indexOnPage = index % limit;

    final res = ref.watch(paginatedCatsProvider(page));
    return res.whenData((e) => e.cats[indexOnPage]);
  },
  dependencies: [paginatedCatsProvider],
);
