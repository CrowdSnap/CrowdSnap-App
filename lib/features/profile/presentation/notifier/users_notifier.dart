import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_notifier.g.dart';

class UsersState {
  final int index;

  UsersState({this.index = 0});

  UsersState copyWith({
    int? index,
  }) {
    return UsersState(
      index: index ?? this.index,
    );
  }
}

@Riverpod(keepAlive: true)
class UsersNotifier extends _$UsersNotifier {
  @override
  UsersState build() {
    return UsersState();
  }

  void updateIndex(int index) {
    state = state.copyWith(index: index);
  }
}