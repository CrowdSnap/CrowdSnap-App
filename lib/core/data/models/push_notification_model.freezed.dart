// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNotificationModel _$PushNotificationModelFromJson(
    Map<String, dynamic> json) {
  return _PushNotificationModel.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationModel {
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get blurHashImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PushNotificationModelCopyWith<PushNotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationModelCopyWith<$Res> {
  factory $PushNotificationModelCopyWith(PushNotificationModel value,
          $Res Function(PushNotificationModel) then) =
      _$PushNotificationModelCopyWithImpl<$Res, PushNotificationModel>;
  @useResult
  $Res call(
      {String title,
      String body,
      String? fcmToken,
      String imageUrl,
      String userId,
      String username,
      String avatarUrl,
      String blurHashImage});
}

/// @nodoc
class _$PushNotificationModelCopyWithImpl<$Res,
        $Val extends PushNotificationModel>
    implements $PushNotificationModelCopyWith<$Res> {
  _$PushNotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? fcmToken = freezed,
    Object? imageUrl = null,
    Object? userId = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? blurHashImage = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      blurHashImage: null == blurHashImage
          ? _value.blurHashImage
          : blurHashImage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PushNotificationModelImplCopyWith<$Res>
    implements $PushNotificationModelCopyWith<$Res> {
  factory _$$PushNotificationModelImplCopyWith(
          _$PushNotificationModelImpl value,
          $Res Function(_$PushNotificationModelImpl) then) =
      __$$PushNotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String body,
      String? fcmToken,
      String imageUrl,
      String userId,
      String username,
      String avatarUrl,
      String blurHashImage});
}

/// @nodoc
class __$$PushNotificationModelImplCopyWithImpl<$Res>
    extends _$PushNotificationModelCopyWithImpl<$Res,
        _$PushNotificationModelImpl>
    implements _$$PushNotificationModelImplCopyWith<$Res> {
  __$$PushNotificationModelImplCopyWithImpl(_$PushNotificationModelImpl _value,
      $Res Function(_$PushNotificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? fcmToken = freezed,
    Object? imageUrl = null,
    Object? userId = null,
    Object? username = null,
    Object? avatarUrl = null,
    Object? blurHashImage = null,
  }) {
    return _then(_$PushNotificationModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      blurHashImage: null == blurHashImage
          ? _value.blurHashImage
          : blurHashImage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotificationModelImpl implements _PushNotificationModel {
  const _$PushNotificationModelImpl(
      {required this.title,
      required this.body,
      this.fcmToken,
      required this.imageUrl,
      required this.userId,
      required this.username,
      required this.avatarUrl,
      required this.blurHashImage});

  factory _$PushNotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PushNotificationModelImplFromJson(json);

  @override
  final String title;
  @override
  final String body;
  @override
  final String? fcmToken;
  @override
  final String imageUrl;
  @override
  final String userId;
  @override
  final String username;
  @override
  final String avatarUrl;
  @override
  final String blurHashImage;

  @override
  String toString() {
    return 'PushNotificationModel(title: $title, body: $body, fcmToken: $fcmToken, imageUrl: $imageUrl, userId: $userId, username: $username, avatarUrl: $avatarUrl, blurHashImage: $blurHashImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotificationModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.blurHashImage, blurHashImage) ||
                other.blurHashImage == blurHashImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, body, fcmToken, imageUrl,
      userId, username, avatarUrl, blurHashImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotificationModelImplCopyWith<_$PushNotificationModelImpl>
      get copyWith => __$$PushNotificationModelImplCopyWithImpl<
          _$PushNotificationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotificationModelImplToJson(
      this,
    );
  }
}

abstract class _PushNotificationModel implements PushNotificationModel {
  const factory _PushNotificationModel(
      {required final String title,
      required final String body,
      final String? fcmToken,
      required final String imageUrl,
      required final String userId,
      required final String username,
      required final String avatarUrl,
      required final String blurHashImage}) = _$PushNotificationModelImpl;

  factory _PushNotificationModel.fromJson(Map<String, dynamic> json) =
      _$PushNotificationModelImpl.fromJson;

  @override
  String get title;
  @override
  String get body;
  @override
  String? get fcmToken;
  @override
  String get imageUrl;
  @override
  String get userId;
  @override
  String get username;
  @override
  String get avatarUrl;
  @override
  String get blurHashImage;
  @override
  @JsonKey(ignore: true)
  _$$PushNotificationModelImplCopyWith<_$PushNotificationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
