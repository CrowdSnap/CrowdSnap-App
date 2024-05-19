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
  String? get mongoId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userAvatarUrl => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  List<String> get taggedUserIds => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  List<LikeModel> get likes => throw _privateConstructorUsedError;
  List<CommentModel> get comments => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

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
      {String? mongoId,
      String userId,
      String userName,
      String userAvatarUrl,
      String imageUrl,
      List<String> taggedUserIds,
      String location,
      DateTime createdAt,
      int likeCount,
      int commentCount,
      List<LikeModel> likes,
      List<CommentModel> comments,
      String? description});
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
    Object? mongoId = freezed,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatarUrl = null,
    Object? imageUrl = null,
    Object? taggedUserIds = null,
    Object? location = null,
    Object? createdAt = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? likes = null,
    Object? comments = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      mongoId: freezed == mongoId
          ? _value.mongoId
          : mongoId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatarUrl: null == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
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
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<LikeModel>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentModel>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String? mongoId,
      String userId,
      String userName,
      String userAvatarUrl,
      String imageUrl,
      List<String> taggedUserIds,
      String location,
      DateTime createdAt,
      int likeCount,
      int commentCount,
      List<LikeModel> likes,
      List<CommentModel> comments,
      String? description});
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
    Object? mongoId = freezed,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatarUrl = null,
    Object? imageUrl = null,
    Object? taggedUserIds = null,
    Object? location = null,
    Object? createdAt = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? likes = null,
    Object? comments = null,
    Object? description = freezed,
  }) {
    return _then(_$PostModelImpl(
      mongoId: freezed == mongoId
          ? _value.mongoId
          : mongoId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatarUrl: null == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
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
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      likes: null == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<LikeModel>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentModel>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {this.mongoId,
      required this.userId,
      required this.userName,
      required this.userAvatarUrl,
      required this.imageUrl,
      required final List<String> taggedUserIds,
      required this.location,
      required this.createdAt,
      required this.likeCount,
      required this.commentCount,
      required final List<LikeModel> likes,
      required final List<CommentModel> comments,
      this.description})
      : _taggedUserIds = taggedUserIds,
        _likes = likes,
        _comments = comments;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String? mongoId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userAvatarUrl;
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
  final int likeCount;
  @override
  final int commentCount;
  final List<LikeModel> _likes;
  @override
  List<LikeModel> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  final List<CommentModel> _comments;
  @override
  List<CommentModel> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final String? description;

  @override
  String toString() {
    return 'PostModel(mongoId: $mongoId, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, imageUrl: $imageUrl, taggedUserIds: $taggedUserIds, location: $location, createdAt: $createdAt, likeCount: $likeCount, commentCount: $commentCount, likes: $likes, comments: $comments, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.mongoId, mongoId) || other.mongoId == mongoId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatarUrl, userAvatarUrl) ||
                other.userAvatarUrl == userAvatarUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._taggedUserIds, _taggedUserIds) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mongoId,
      userId,
      userName,
      userAvatarUrl,
      imageUrl,
      const DeepCollectionEquality().hash(_taggedUserIds),
      location,
      createdAt,
      likeCount,
      commentCount,
      const DeepCollectionEquality().hash(_likes),
      const DeepCollectionEquality().hash(_comments),
      description);

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
      {final String? mongoId,
      required final String userId,
      required final String userName,
      required final String userAvatarUrl,
      required final String imageUrl,
      required final List<String> taggedUserIds,
      required final String location,
      required final DateTime createdAt,
      required final int likeCount,
      required final int commentCount,
      required final List<LikeModel> likes,
      required final List<CommentModel> comments,
      final String? description}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String? get mongoId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userAvatarUrl;
  @override
  String get imageUrl;
  @override
  List<String> get taggedUserIds;
  @override
  String get location;
  @override
  DateTime get createdAt;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  List<LikeModel> get likes;
  @override
  List<CommentModel> get comments;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
