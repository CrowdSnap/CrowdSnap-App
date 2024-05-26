// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProviderHash() => r'6dc3846dab94a7f0ed5684433261ce8014896a9f';

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

/// See also [userProvider].
@ProviderFor(userProvider)
const userProviderProvider = UserProviderFamily();

/// See also [userProvider].
class UserProviderFamily extends Family<AsyncValue<UserModel>> {
  /// See also [userProvider].
  const UserProviderFamily();

  /// See also [userProvider].
  UserProviderProvider call(
    String userId,
  ) {
    return UserProviderProvider(
      userId,
    );
  }

  @override
  UserProviderProvider getProviderOverride(
    covariant UserProviderProvider provider,
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
  String? get name => r'userProviderProvider';
}

/// See also [userProvider].
class UserProviderProvider extends AutoDisposeFutureProvider<UserModel> {
  /// See also [userProvider].
  UserProviderProvider(
    String userId,
  ) : this._internal(
          (ref) => userProvider(
            ref as UserProviderRef,
            userId,
          ),
          from: userProviderProvider,
          name: r'userProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProviderHash,
          dependencies: UserProviderFamily._dependencies,
          allTransitiveDependencies:
              UserProviderFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProviderProvider._internal(
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
    FutureOr<UserModel> Function(UserProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProviderProvider._internal(
        (ref) => create(ref as UserProviderRef),
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
  AutoDisposeFutureProviderElement<UserModel> createElement() {
    return _UserProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProviderProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProviderRef on AutoDisposeFutureProviderRef<UserModel> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProviderProviderElement
    extends AutoDisposeFutureProviderElement<UserModel> with UserProviderRef {
  _UserProviderProviderElement(super.provider);

  @override
  String get userId => (origin as UserProviderProvider).userId;
}

String _$getUserUseCaseHash() => r'c35687d15cd149ec5e5f5d88c5e4f02ebad889d1';

/// See also [getUserUseCase].
@ProviderFor(getUserUseCase)
final getUserUseCaseProvider = Provider<GetUserUseCase>.internal(
  getUserUseCase,
  name: r'getUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUserUseCaseRef = ProviderRef<GetUserUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
