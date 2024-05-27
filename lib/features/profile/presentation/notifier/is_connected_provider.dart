import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_connected_provider.g.dart';

class IsConnectedState {
  final bool isConnected;

  IsConnectedState(this.isConnected);

  IsConnectedState copyWith({bool? isConnected}) {
    return IsConnectedState(isConnected ?? this.isConnected);
  }
}

@riverpod
class IsConnected extends _$IsConnected {
  @override
  IsConnectedState build(bool initialIsConnected) {
    return IsConnectedState(initialIsConnected);
  }

  void setConnected() {
    state = state.copyWith(isConnected: true);
  }

  void setDisconnected() {
    state = state.copyWith(isConnected: false);
  }
}