import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_scroll.g.dart';

@riverpod
class BlockScroll extends _$BlockScroll {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setBlockScroll(bool value) {
    state = value;
  }
}
