// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_create_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createCommentUseCaseHash() =>
    r'fe55a978c9fe4c70441f8154d719f1361aac3b59';

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

/// See also [createCommentUseCase].
@ProviderFor(createCommentUseCase)
const createCommentUseCaseProvider = CreateCommentUseCaseFamily();

/// See also [createCommentUseCase].
class CreateCommentUseCaseFamily extends Family<CreateCommentUseCase> {
  /// See also [createCommentUseCase].
  const CreateCommentUseCaseFamily();

  /// See also [createCommentUseCase].
  CreateCommentUseCaseProvider call(
    String postId,
  ) {
    return CreateCommentUseCaseProvider(
      postId,
    );
  }

  @override
  CreateCommentUseCaseProvider getProviderOverride(
    covariant CreateCommentUseCaseProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'createCommentUseCaseProvider';
}

/// See also [createCommentUseCase].
class CreateCommentUseCaseProvider
    extends AutoDisposeProvider<CreateCommentUseCase> {
  /// See also [createCommentUseCase].
  CreateCommentUseCaseProvider(
    String postId,
  ) : this._internal(
          (ref) => createCommentUseCase(
            ref as CreateCommentUseCaseRef,
            postId,
          ),
          from: createCommentUseCaseProvider,
          name: r'createCommentUseCaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createCommentUseCaseHash,
          dependencies: CreateCommentUseCaseFamily._dependencies,
          allTransitiveDependencies:
              CreateCommentUseCaseFamily._allTransitiveDependencies,
          postId: postId,
        );

  CreateCommentUseCaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    CreateCommentUseCase Function(CreateCommentUseCaseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateCommentUseCaseProvider._internal(
        (ref) => create(ref as CreateCommentUseCaseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CreateCommentUseCase> createElement() {
    return _CreateCommentUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCommentUseCaseProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreateCommentUseCaseRef on AutoDisposeProviderRef<CreateCommentUseCase> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _CreateCommentUseCaseProviderElement
    extends AutoDisposeProviderElement<CreateCommentUseCase>
    with CreateCommentUseCaseRef {
  _CreateCommentUseCaseProviderElement(super.provider);

  @override
  String get postId => (origin as CreateCommentUseCaseProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
