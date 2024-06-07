import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tagged_user_ids_provider.g.dart';

@Riverpod(keepAlive: true)
class TaggedUserIdsProvider extends _$TaggedUserIdsProvider {
  @override
  List<String> build() => [];

  void addUserId(String userId) {
    state = [...state, userId];
    print('state: $state');
  }

  void removeUserId(String userId) {
    state = state.where((id) => id != userId).toList();
  }

  void clearUserIds() {
    state = [];
  }
}