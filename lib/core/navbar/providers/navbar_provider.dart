import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navbar_provider.g.dart';

@riverpod
class NavBarIndexNotifier extends _$NavBarIndexNotifier {
  @override
  int build() {
    return 0;
  }

  void updateIndex(int index) {
    state = index;
  }
}