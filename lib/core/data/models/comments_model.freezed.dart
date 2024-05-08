// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comments_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommentsModel _$CommentsModelFromJson(Map<String, dynamic> json) {
  return _CommentsModel.fromJson(json);
}

/// @nodoc
mixin _$CommentsModel {
  String get commentId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get likes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentsModelCopyWith<CommentsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentsModelCopyWith<$Res> {
  factory $CommentsModelCopyWith(
          CommentsModel value, $Res Function(CommentsModel) then) =
      _$CommentsModelCopyWithImpl<$Res, CommentsModel>;
  @useResult
  $Res call(
      {String commentId,
      String userId,
      String comment,
      DateTime createdAt,
      int? likes});
}

/// @nodoc
class _$CommentsModelCopyWithImpl<$Res, $Val extends CommentsModel>
    implements $CommentsModelCopyWith<$Res> {
  _$CommentsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? userId = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? likes = freezed,
  }) {
    return _then(_value.copyWith(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentsModelImplCopyWith<$Res>
    implements $CommentsModelCopyWith<$Res> {
  factory _$$CommentsModelImplCopyWith(
          _$CommentsModelImpl value, $Res Function(_$CommentsModelImpl) then) =
      __$$CommentsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String commentId,
      String userId,
      String comment,
      DateTime createdAt,
      int? likes});
}

/// @nodoc
class __$$CommentsModelImplCopyWithImpl<$Res>
    extends _$CommentsModelCopyWithImpl<$Res, _$CommentsModelImpl>
    implements _$$CommentsModelImplCopyWith<$Res> {
  __$$CommentsModelImplCopyWithImpl(
      _$CommentsModelImpl _value, $Res Function(_$CommentsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? userId = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? likes = freezed,
  }) {
    return _then(_$CommentsModelImpl(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentsModelImpl implements _CommentsModel {
  const _$CommentsModelImpl(
      {required this.commentId,
      required this.userId,
      required this.comment,
      required this.createdAt,
      this.likes});

  factory _$CommentsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentsModelImplFromJson(json);

  @override
  final String commentId;
  @override
  final String userId;
  @override
  final String comment;
  @override
  final DateTime createdAt;
  @override
  final int? likes;

  @override
  String toString() {
    return 'CommentsModel(commentId: $commentId, userId: $userId, comment: $comment, createdAt: $createdAt, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentsModelImpl &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likes, likes) || other.likes == likes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, commentId, userId, comment, createdAt, likes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentsModelImplCopyWith<_$CommentsModelImpl> get copyWith =>
      __$$CommentsModelImplCopyWithImpl<_$CommentsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentsModelImplToJson(
      this,
    );
  }
}

abstract class _CommentsModel implements CommentsModel {
  const factory _CommentsModel(
      {required final String commentId,
      required final String userId,
      required final String comment,
      required final DateTime createdAt,
      final int? likes}) = _$CommentsModelImpl;

  factory _CommentsModel.fromJson(Map<String, dynamic> json) =
      _$CommentsModelImpl.fromJson;

  @override
  String get commentId;
  @override
  String get userId;
  @override
  String get comment;
  @override
  DateTime get createdAt;
  @override
  int? get likes;
  @override
  @JsonKey(ignore: true)
  _$$CommentsModelImplCopyWith<_$CommentsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
