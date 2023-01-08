import 'package:flutter/foundation.dart';

@immutable
class PaginatedResponse {
  const PaginatedResponse(this.cats, this.totalCount);

  final List<Cat> cats;
  final int totalCount;

  factory PaginatedResponse.fromJson(Map<String, Object?> map) {
    return PaginatedResponse(
      (map['data'] as List).map((x) => Cat.fromJson(x)).toList(),
      map['total'] as int,
    );
  }
}

@immutable
class Cat {
  const Cat(this.fact);
  final String fact;

  factory Cat.fromJson(Map<String, Object?> map) => Cat(map['fact'] as String);
}
