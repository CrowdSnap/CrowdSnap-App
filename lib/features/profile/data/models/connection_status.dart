enum ConnectionStatus {
  connected,
  pending,
  waitingForAcceptance,
  rejected,
  none,
}

extension ConnectionStatusExtension on ConnectionStatus {
  String get value {
    switch (this) {
      case ConnectionStatus.connected:
        return 'connected';
      case ConnectionStatus.pending:
        return 'pending';
      case ConnectionStatus.waitingForAcceptance:
        return 'waitingForAcceptance';
      case ConnectionStatus.rejected:
        return 'rejected';
      case ConnectionStatus.none:
        return 'none';
    }
  }
}
