import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_auth_provider.g.dart';

@riverpod
class PageAuth extends _$PageAuth {
  @override
  bool build() {
    return false; // Valor inicial del estado booleano
  }

  /// Método para actualizar el estado booleano
  void setTrue() {
    state = true;
  }

  /// Método para actualizar el estado booleano
  void setFalse() {
    state = false;
  }
}
