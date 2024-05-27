// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectionStatusProviderHash() =>
    r'e3991689d3de0950888359c22bba8e9e90bf7fea';

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

/// See also [connectionStatusProvider].
@ProviderFor(connectionStatusProvider)
const connectionStatusProviderProvider = ConnectionStatusProviderFamily();

/// See also [connectionStatusProvider].
class ConnectionStatusProviderFamily extends Family<AsyncValue<bool>> {
  /// See also [connectionStatusProvider].
  const ConnectionStatusProviderFamily();

  /// See also [connectionStatusProvider].
  ConnectionStatusProviderProvider call(
    String userId,
  ) {
    return ConnectionStatusProviderProvider(
      userId,
    );
  }

  @override
  ConnectionStatusProviderProvider getProviderOverride(
    covariant ConnectionStatusProviderProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'connectionStatusProviderProvider';
}

/// See also [connectionStatusProvider].
class ConnectionStatusProviderProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [connectionStatusProvider].
  ConnectionStatusProviderProvider(
    String userId,
  ) : this._internal(
          (ref) => connectionStatusProvider(
            ref as ConnectionStatusProviderRef,
            userId,
          ),
          from: connectionStatusProviderProvider,
          name: r'connectionStatusProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$connectionStatusProviderHash,
          dependencies: ConnectionStatusProviderFamily._dependencies,
          allTransitiveDependencies:
              ConnectionStatusProviderFamily._allTransitiveDependencies,
          userId: userId,
        );

  ConnectionStatusProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ConnectionStatusProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConnectionStatusProviderProvider._internal(
        (ref) => create(ref as ConnectionStatusProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ConnectionStatusProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectionStatusProviderProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConnectionStatusProviderRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ConnectionStatusProviderProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ConnectionStatusProviderRef {
  _ConnectionStatusProviderProviderElement(super.provider);

  @override
  String get userId => (origin as ConnectionStatusProviderProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
