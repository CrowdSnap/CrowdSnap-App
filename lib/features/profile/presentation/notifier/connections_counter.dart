import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connections_counter.g.dart';

class ConnectionsCounterState {
  final int count;

  ConnectionsCounterState(this.count);

  ConnectionsCounterState copyWith({int? count}) {
    return ConnectionsCounterState(count ?? this.count);
  }
}

@riverpod
class ConnectionsCounter extends _$ConnectionsCounter {
  @override
  ConnectionsCounterState build(int initialCount) {
    return ConnectionsCounterState(initialCount);
  }

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }
}