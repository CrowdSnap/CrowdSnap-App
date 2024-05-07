// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get userId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  List<String> get taggedUserIds => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String userId,
      String imageUrl,
      List<String> taggedUserIds,
      String location,
      DateTime createdAt});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? imageUrl = null,
    Object? taggedUserIds = null,
    Object? location = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      taggedUserIds: null == taggedUserIds
          ? _value.taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String imageUrl,
      List<String> taggedUserIds,
      String location,
      DateTime createdAt});
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? imageUrl = null,
    Object? taggedUserIds = null,
    Object? location = null,
    Object? createdAt = null,
  }) {
    return _then(_$PostModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      taggedUserIds: null == taggedUserIds
          ? _value._taggedUserIds
          : taggedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {required this.userId,
      required this.imageUrl,
      required final List<String> taggedUserIds,
      required this.location,
      required this.createdAt})
      : _taggedUserIds = taggedUserIds;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String imageUrl;
  final List<String> _taggedUserIds;
  @override
  List<String> get taggedUserIds {
    if (_taggedUserIds is EqualUnmodifiableListView) return _taggedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taggedUserIds);
  }

  @override
  final String location;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PostModel(userId: $userId, imageUrl: $imageUrl, taggedUserIds: $taggedUserIds, location: $location, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._taggedUserIds, _taggedUserIds) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, imageUrl,
      const DeepCollectionEquality().hash(_taggedUserIds), location, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final String userId,
      required final String imageUrl,
      required final List<String> taggedUserIds,
      required final String location,
      required final DateTime createdAt}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get imageUrl;
  @override
  List<String> get taggedUserIds;
  @override
  String get location;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
