// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_redirect_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateChangesHash() => r'06c05eec5a6c9127c308a9d2edb0019c311705c4';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = AutoDisposeStreamProvider<User?>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateChangesRef = AutoDisposeStreamProviderRef<User?>;
String _$authRedirectHash() => r'767764a277155fc80b90677336300a444daabf3c';

/// See also [authRedirect].
@ProviderFor(authRedirect)
final authRedirectProvider = AutoDisposeProvider<void>.internal(
  authRedirect,
  name: r'authRedirectProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authRedirectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRedirectRef = AutoDisposeProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member