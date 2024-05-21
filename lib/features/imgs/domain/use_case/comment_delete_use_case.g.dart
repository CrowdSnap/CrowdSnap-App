// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_delete_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteCommentUseCaseHash() =>
    r'4960128aee6e4cc5cdc33bb98a2c70f04b2a1e22';

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

/// See also [deleteCommentUseCase].
@ProviderFor(deleteCommentUseCase)
const deleteCommentUseCaseProvider = DeleteCommentUseCaseFamily();

/// See also [deleteCommentUseCase].
class DeleteCommentUseCaseFamily extends Family<DeleteCommentUseCase> {
  /// See also [deleteCommentUseCase].
  const DeleteCommentUseCaseFamily();

  /// See also [deleteCommentUseCase].
  DeleteCommentUseCaseProvider call(
    String postId,
  ) {
    return DeleteCommentUseCaseProvider(
      postId,
    );
  }

  @override
  DeleteCommentUseCaseProvider getProviderOverride(
    covariant DeleteCommentUseCaseProvider provider,
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
  String? get name => r'deleteCommentUseCaseProvider';
}

/// See also [deleteCommentUseCase].
class DeleteCommentUseCaseProvider
    extends AutoDisposeProvider<DeleteCommentUseCase> {
  /// See also [deleteCommentUseCase].
  DeleteCommentUseCaseProvider(
    String postId,
  ) : this._internal(
          (ref) => deleteCommentUseCase(
            ref as DeleteCommentUseCaseRef,
            postId,
          ),
          from: deleteCommentUseCaseProvider,
          name: r'deleteCommentUseCaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteCommentUseCaseHash,
          dependencies: DeleteCommentUseCaseFamily._dependencies,
          allTransitiveDependencies:
              DeleteCommentUseCaseFamily._allTransitiveDependencies,
          postId: postId,
        );

  DeleteCommentUseCaseProvider._internal(
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
    DeleteCommentUseCase Function(DeleteCommentUseCaseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteCommentUseCaseProvider._internal(
        (ref) => create(ref as DeleteCommentUseCaseRef),
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
  AutoDisposeProviderElement<DeleteCommentUseCase> createElement() {
    return _DeleteCommentUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteCommentUseCaseProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteCommentUseCaseRef on AutoDisposeProviderRef<DeleteCommentUseCase> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _DeleteCommentUseCaseProviderElement
    extends AutoDisposeProviderElement<DeleteCommentUseCase>
    with DeleteCommentUseCaseRef {
  _DeleteCommentUseCaseProviderElement(super.provider);

  @override
  String get postId => (origin as DeleteCommentUseCaseProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
