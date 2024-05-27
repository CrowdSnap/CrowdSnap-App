// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_posts_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostsProviderHash() => r'c5bb4687e3ef7030ea3a2df732f32172f39acab0';

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

/// See also [userPostsProvider].
@ProviderFor(userPostsProvider)
const userPostsProviderProvider = UserPostsProviderFamily();

/// See also [userPostsProvider].
class UserPostsProviderFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [userPostsProvider].
  const UserPostsProviderFamily();

  /// See also [userPostsProvider].
  UserPostsProviderProvider call(
    String userId,
  ) {
    return UserPostsProviderProvider(
      userId,
    );
  }

  @override
  UserPostsProviderProvider getProviderOverride(
    covariant UserPostsProviderProvider provider,
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
  String? get name => r'userPostsProviderProvider';
}

/// See also [userPostsProvider].
class UserPostsProviderProvider
    extends AutoDisposeFutureProvider<List<PostModel>> {
  /// See also [userPostsProvider].
  UserPostsProviderProvider(
    String userId,
  ) : this._internal(
          (ref) => userPostsProvider(
            ref as UserPostsProviderRef,
            userId,
          ),
          from: userPostsProviderProvider,
          name: r'userPostsProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostsProviderHash,
          dependencies: UserPostsProviderFamily._dependencies,
          allTransitiveDependencies:
              UserPostsProviderFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserPostsProviderProvider._internal(
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
    FutureOr<List<PostModel>> Function(UserPostsProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPostsProviderProvider._internal(
        (ref) => create(ref as UserPostsProviderRef),
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
  AutoDisposeFutureProviderElement<List<PostModel>> createElement() {
    return _UserPostsProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsProviderProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserPostsProviderRef on AutoDisposeFutureProviderRef<List<PostModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserPostsProviderProviderElement
    extends AutoDisposeFutureProviderElement<List<PostModel>>
    with UserPostsProviderRef {
  _UserPostsProviderProviderElement(super.provider);

  @override
  String get userId => (origin as UserPostsProviderProvider).userId;
}

String _$getUserPostsUseCaseHash() =>
    r'0739f4f3e28046338c65e7b76b87a4af4d9be099';

/// See also [getUserPostsUseCase].
@ProviderFor(getUserPostsUseCase)
final getUserPostsUseCaseProvider = Provider<GetUserPostsUseCase>.internal(
  getUserPostsUseCase,
  name: r'getUserPostsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserPostsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUserPostsUseCaseRef = ProviderRef<GetUserPostsUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
