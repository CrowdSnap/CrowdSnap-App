// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_up_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$googleUserHash() => r'6783f2f123e1b44c39a74cb807704a1d523a9920';

/// See also [googleUser].
@ProviderFor(googleUser)
final googleUserProvider = AutoDisposeFutureProvider<GoogleUserModel>.internal(
  googleUser,
  name: r'googleUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$googleUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoogleUserRef = AutoDisposeFutureProviderRef<GoogleUserModel>;
String _$googleSignUpNotifierHash() =>
    r'f851c66ecaa9aae195184bac5efd7e8f94a180a0';

/// See also [GoogleSignUpNotifier].
@ProviderFor(GoogleSignUpNotifier)
final googleSignUpNotifierProvider = AutoDisposeNotifierProvider<
    GoogleSignUpNotifier, GoogleSignUpState>.internal(
  GoogleSignUpNotifier.new,
  name: r'googleSignUpNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleSignUpNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GoogleSignUpNotifier = AutoDisposeNotifier<GoogleSignUpState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
