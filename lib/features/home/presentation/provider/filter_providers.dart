import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_providers.g.dart';

@riverpod
class StartDate extends _$StartDate {
  @override
  DateTime? build() => null;

  void setStartDate(DateTime date) => state = date;
}

@riverpod
class EndDate extends _$EndDate {
  @override
  DateTime? build() => null;

  void setEndDate(DateTime date) => state = date;
}

@riverpod
class City extends _$City {
  @override
  String? build() => null;

  void setCity(String city) => state = city;
}

@riverpod
class NumberOfPosts extends _$NumberOfPosts {
  @override
  int build() => 3;

  void setNumberOfPosts(int number) => state = number;
}