// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_connection_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$removeConnectionProviderHash() =>
    r'b28c29505b38fd64f982f92324ba1c15a03eff9c';

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

/// See also [removeConnectionProvider].
@ProviderFor(removeConnectionProvider)
const removeConnectionProviderProvider = RemoveConnectionProviderFamily();

/// See also [removeConnectionProvider].
class RemoveConnectionProviderFamily extends Family<AsyncValue<void>> {
  /// See also [removeConnectionProvider].
  const RemoveConnectionProviderFamily();

  /// See also [removeConnectionProvider].
  RemoveConnectionProviderProvider call(
    String userId,
    String connectionId,
  ) {
    return RemoveConnectionProviderProvider(
      userId,
      connectionId,
    );
  }

  @override
  RemoveConnectionProviderProvider getProviderOverride(
    covariant RemoveConnectionProviderProvider provider,
  ) {
    return call(
      provider.userId,
      provider.connectionId,
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
  String? get name => r'removeConnectionProviderProvider';
}

/// See also [removeConnectionProvider].
class RemoveConnectionProviderProvider extends AutoDisposeFutureProvider<void> {
  /// See also [removeConnectionProvider].
  RemoveConnectionProviderProvider(
    String userId,
    String connectionId,
  ) : this._internal(
          (ref) => removeConnectionProvider(
            ref as RemoveConnectionProviderRef,
            userId,
            connectionId,
          ),
          from: removeConnectionProviderProvider,
          name: r'removeConnectionProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$removeConnectionProviderHash,
          dependencies: RemoveConnectionProviderFamily._dependencies,
          allTransitiveDependencies:
              RemoveConnectionProviderFamily._allTransitiveDependencies,
          userId: userId,
          connectionId: connectionId,
        );

  RemoveConnectionProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.connectionId,
  }) : super.internal();

  final String userId;
  final String connectionId;

  @override
  Override overrideWith(
    FutureOr<void> Function(RemoveConnectionProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoveConnectionProviderProvider._internal(
        (ref) => create(ref as RemoveConnectionProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        connectionId: connectionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RemoveConnectionProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveConnectionProviderProvider &&
        other.userId == userId &&
        other.connectionId == connectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, connectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoveConnectionProviderRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `connectionId` of this provider.
  String get connectionId;
}

class _RemoveConnectionProviderProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RemoveConnectionProviderRef {
  _RemoveConnectionProviderProviderElement(super.provider);

  @override
  String get userId => (origin as RemoveConnectionProviderProvider).userId;
  @override
  String get connectionId =>
      (origin as RemoveConnectionProviderProvider).connectionId;
}

String _$removeConnectionUseCaseHash() =>
    r'857d5970a0cc3af9c576c60bb0f12d9f485a35d8';

/// See also [removeConnectionUseCase].
@ProviderFor(removeConnectionUseCase)
final removeConnectionUseCaseProvider =
    Provider<RemoveConnectionUseCase>.internal(
  removeConnectionUseCase,
  name: r'removeConnectionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$removeConnectionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemoveConnectionUseCaseRef = ProviderRef<RemoveConnectionUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
