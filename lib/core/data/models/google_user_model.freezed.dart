// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoogleUserModel _$GoogleUserModelFromJson(Map<String, dynamic> json) {
  return _GoogleUserModel.fromJson(json);
}

/// @nodoc
mixin _$GoogleUserModel {
  String get userId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  bool? get firstTime => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoogleUserModelCopyWith<GoogleUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleUserModelCopyWith<$Res> {
  factory $GoogleUserModelCopyWith(
          GoogleUserModel value, $Res Function(GoogleUserModel) then) =
      _$GoogleUserModelCopyWithImpl<$Res, GoogleUserModel>;
  @useResult
  $Res call(
      {String userId,
      String? name,
      String? email,
      DateTime joinedAt,
      bool? firstTime,
      String? avatarUrl});
}

/// @nodoc
class _$GoogleUserModelCopyWithImpl<$Res, $Val extends GoogleUserModel>
    implements $GoogleUserModelCopyWith<$Res> {
  _$GoogleUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? joinedAt = null,
    Object? firstTime = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firstTime: freezed == firstTime
          ? _value.firstTime
          : firstTime // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleUserModelImplCopyWith<$Res>
    implements $GoogleUserModelCopyWith<$Res> {
  factory _$$GoogleUserModelImplCopyWith(_$GoogleUserModelImpl value,
          $Res Function(_$GoogleUserModelImpl) then) =
      __$$GoogleUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? name,
      String? email,
      DateTime joinedAt,
      bool? firstTime,
      String? avatarUrl});
}

/// @nodoc
class __$$GoogleUserModelImplCopyWithImpl<$Res>
    extends _$GoogleUserModelCopyWithImpl<$Res, _$GoogleUserModelImpl>
    implements _$$GoogleUserModelImplCopyWith<$Res> {
  __$$GoogleUserModelImplCopyWithImpl(
      _$GoogleUserModelImpl _value, $Res Function(_$GoogleUserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? joinedAt = null,
    Object? firstTime = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$GoogleUserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firstTime: freezed == firstTime
          ? _value.firstTime
          : firstTime // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleUserModelImpl implements _GoogleUserModel {
  const _$GoogleUserModelImpl(
      {required this.userId,
      this.name,
      this.email,
      required this.joinedAt,
      this.firstTime,
      this.avatarUrl});

  factory _$GoogleUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleUserModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final DateTime joinedAt;
  @override
  final bool? firstTime;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'GoogleUserModel(userId: $userId, name: $name, email: $email, joinedAt: $joinedAt, firstTime: $firstTime, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleUserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.firstTime, firstTime) ||
                other.firstTime == firstTime) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, name, email, joinedAt, firstTime, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleUserModelImplCopyWith<_$GoogleUserModelImpl> get copyWith =>
      __$$GoogleUserModelImplCopyWithImpl<_$GoogleUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleUserModelImplToJson(
      this,
    );
  }
}

abstract class _GoogleUserModel implements GoogleUserModel {
  const factory _GoogleUserModel(
      {required final String userId,
      final String? name,
      final String? email,
      required final DateTime joinedAt,
      final bool? firstTime,
      final String? avatarUrl}) = _$GoogleUserModelImpl;

  factory _GoogleUserModel.fromJson(Map<String, dynamic> json) =
      _$GoogleUserModelImpl.fromJson;

  @override
  String get userId;
  @override
  String? get name;
  @override
  String? get email;
  @override
  DateTime get joinedAt;
  @override
  bool? get firstTime;
  @override
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$GoogleUserModelImplCopyWith<_$GoogleUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
