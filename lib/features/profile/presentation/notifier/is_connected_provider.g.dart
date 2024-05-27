// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_connected_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isConnectedHash() => r'aa699f065a193eb9aff785452fd2fdffc7ab015c';

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

abstract class _$IsConnected
    extends BuildlessAutoDisposeNotifier<IsConnectedState> {
  late final bool initialIsConnected;

  IsConnectedState build(
    bool initialIsConnected,
  );
}

/// See also [IsConnected].
@ProviderFor(IsConnected)
const isConnectedProvider = IsConnectedFamily();

/// See also [IsConnected].
class IsConnectedFamily extends Family<IsConnectedState> {
  /// See also [IsConnected].
  const IsConnectedFamily();

  /// See also [IsConnected].
  IsConnectedProvider call(
    bool initialIsConnected,
  ) {
    return IsConnectedProvider(
      initialIsConnected,
    );
  }

  @override
  IsConnectedProvider getProviderOverride(
    covariant IsConnectedProvider provider,
  ) {
    return call(
      provider.initialIsConnected,
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
  String? get name => r'isConnectedProvider';
}

/// See also [IsConnected].
class IsConnectedProvider
    extends AutoDisposeNotifierProviderImpl<IsConnected, IsConnectedState> {
  /// See also [IsConnected].
  IsConnectedProvider(
    bool initialIsConnected,
  ) : this._internal(
          () => IsConnected()..initialIsConnected = initialIsConnected,
          from: isConnectedProvider,
          name: r'isConnectedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isConnectedHash,
          dependencies: IsConnectedFamily._dependencies,
          allTransitiveDependencies:
              IsConnectedFamily._allTransitiveDependencies,
          initialIsConnected: initialIsConnected,
        );

  IsConnectedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialIsConnected,
  }) : super.internal();

  final bool initialIsConnected;

  @override
  IsConnectedState runNotifierBuild(
    covariant IsConnected notifier,
  ) {
    return notifier.build(
      initialIsConnected,
    );
  }

  @override
  Override overrideWith(IsConnected Function() create) {
    return ProviderOverride(
      origin: this,
      override: IsConnectedProvider._internal(
        () => create()..initialIsConnected = initialIsConnected,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialIsConnected: initialIsConnected,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<IsConnected, IsConnectedState>
      createElement() {
    return _IsConnectedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsConnectedProvider &&
        other.initialIsConnected == initialIsConnected;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialIsConnected.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsConnectedRef on AutoDisposeNotifierProviderRef<IsConnectedState> {
  /// The parameter `initialIsConnected` of this provider.
  bool get initialIsConnected;
}

class _IsConnectedProviderElement
    extends AutoDisposeNotifierProviderElement<IsConnected, IsConnectedState>
    with IsConnectedRef {
  _IsConnectedProviderElement(super.provider);

  @override
  bool get initialIsConnected =>
      (origin as IsConnectedProvider).initialIsConnected;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
