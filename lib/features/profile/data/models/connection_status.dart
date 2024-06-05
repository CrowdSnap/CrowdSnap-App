import 'package:freezed_annotation/freezed_annotation.dart';

enum ConnectionStatus {
  @JsonValue('connected')
  connected,
  @JsonValue('pending')
  pending,
  @JsonValue('taggingRequest')
  taggingRequest,
  @JsonValue('waitingForAcceptance')
  waitingForAcceptance,
  @JsonValue('rejected')
  rejected,
  @JsonValue('none')
  none,
}

extension ConnectionStatusExtension on ConnectionStatus {
  String get value {
    switch (this) {
      case ConnectionStatus.connected:
        return 'connected';
      case ConnectionStatus.pending:
        return 'pending';
      case ConnectionStatus.taggingRequest:
        return 'taggingRequest';
      case ConnectionStatus.waitingForAcceptance:
        return 'waitingForAcceptance';
      case ConnectionStatus.rejected:
        return 'rejected';
      case ConnectionStatus.none:
        return 'none';
    }
  }

  static ConnectionStatus fromValue(String value) {
    switch (value) {
      case 'connected':
        return ConnectionStatus.connected;
      case 'pending':
        return ConnectionStatus.pending;
      case 'waitingForAcceptance':
        return ConnectionStatus.waitingForAcceptance;
      case 'rejected':
        return ConnectionStatus.rejected;
      case 'none':
        return ConnectionStatus.none;
      default:
        throw Exception('Unknown ConnectionStatus value: $value');
    }
  }
}
