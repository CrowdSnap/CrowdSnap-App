// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_counter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectionsCounterHash() =>
    r'86466e150894d5210a699c04fd384d070b7b41aa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ConnectionsCounter
    extends BuildlessAutoDisposeNotifier<ConnectionsCounterState> {
  late final int initialCount;

  ConnectionsCounterState build(
    int initialCount,
  );
}

/// See also [ConnectionsCounter].
@ProviderFor(ConnectionsCounter)
const connectionsCounterProvider = ConnectionsCounterFamily();

/// See also [ConnectionsCounter].
class ConnectionsCounterFamily extends Family<ConnectionsCounterState> {
  /// See also [ConnectionsCounter].
  const ConnectionsCounterFamily();

  /// See also [ConnectionsCounter].
  ConnectionsCounterProvider call(
    int initialCount,
  ) {
    return ConnectionsCounterProvider(
      initialCount,
    );
  }

  @override
  ConnectionsCounterProvider getProviderOverride(
    covariant ConnectionsCounterProvider provider,
  ) {
    return call(
      provider.initialCount,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'connectionsCounterProvider';
}

/// See also [ConnectionsCounter].
class ConnectionsCounterProvider extends AutoDisposeNotifierProviderImpl<
    ConnectionsCounter, ConnectionsCounterState> {
  /// See also [ConnectionsCounter].
  ConnectionsCounterProvider(
    int initialCount,
  ) : this._internal(
          () => ConnectionsCounter()..initialCount = initialCount,
          from: connectionsCounterProvider,
          name: r'connectionsCounterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$connectionsCounterHash,
          dependencies: ConnectionsCounterFamily._dependencies,
          allTransitiveDependencies:
              ConnectionsCounterFamily._allTransitiveDependencies,
          initialCount: initialCount,
        );

  ConnectionsCounterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialCount,
  }) : super.internal();

  final int initialCount;

  @override
  ConnectionsCounterState runNotifierBuild(
    covariant ConnectionsCounter notifier,
  ) {
    return notifier.build(
      initialCount,
    );
  }

  @override
  Override overrideWith(ConnectionsCounter Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConnectionsCounterProvider._internal(
        () => create()..initialCount = initialCount,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialCount: initialCount,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ConnectionsCounter,
      ConnectionsCounterState> createElement() {
    return _ConnectionsCounterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectionsCounterProvider &&
        other.initialCount == initialCount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialCount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConnectionsCounterRef
    on AutoDisposeNotifierProviderRef<ConnectionsCounterState> {
  /// The parameter `initialCount` of this provider.
  int get initialCount;
}

class _ConnectionsCounterProviderElement
    extends AutoDisposeNotifierProviderElement<ConnectionsCounter,
        ConnectionsCounterState> with ConnectionsCounterRef {
  _ConnectionsCounterProviderElement(super.provider);

  @override
  int get initialCount => (origin as ConnectionsCounterProvider).initialCount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
