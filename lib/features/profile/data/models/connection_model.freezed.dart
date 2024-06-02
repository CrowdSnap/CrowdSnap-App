// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConnectionModel _$ConnectionModelFromJson(Map<String, dynamic> json) {
  return _ConnectionModel.fromJson(json);
}

/// @nodoc
mixin _$ConnectionModel {
  DateTime get connectedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get connectionUserId => throw _privateConstructorUsedError;
  ConnectionStatus get connectionStatus => throw _privateConstructorUsedError;
  String? get connectionPostId => throw _privateConstructorUsedError;
  String? get connectionLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConnectionModelCopyWith<ConnectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionModelCopyWith<$Res> {
  factory $ConnectionModelCopyWith(
          ConnectionModel value, $Res Function(ConnectionModel) then) =
      _$ConnectionModelCopyWithImpl<$Res, ConnectionModel>;
  @useResult
  $Res call(
      {DateTime connectedAt,
      String userId,
      String connectionUserId,
      ConnectionStatus connectionStatus,
      String? connectionPostId,
      String? connectionLocation});
}

/// @nodoc
class _$ConnectionModelCopyWithImpl<$Res, $Val extends ConnectionModel>
    implements $ConnectionModelCopyWith<$Res> {
  _$ConnectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectedAt = null,
    Object? userId = null,
    Object? connectionUserId = null,
    Object? connectionStatus = null,
    Object? connectionPostId = freezed,
    Object? connectionLocation = freezed,
  }) {
    return _then(_value.copyWith(
      connectedAt: null == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      connectionUserId: null == connectionUserId
          ? _value.connectionUserId
          : connectionUserId // ignore: cast_nullable_to_non_nullable
              as String,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
      connectionPostId: freezed == connectionPostId
          ? _value.connectionPostId
          : connectionPostId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionLocation: freezed == connectionLocation
          ? _value.connectionLocation
          : connectionLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectionModelImplCopyWith<$Res>
    implements $ConnectionModelCopyWith<$Res> {
  factory _$$ConnectionModelImplCopyWith(_$ConnectionModelImpl value,
          $Res Function(_$ConnectionModelImpl) then) =
      __$$ConnectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime connectedAt,
      String userId,
      String connectionUserId,
      ConnectionStatus connectionStatus,
      String? connectionPostId,
      String? connectionLocation});
}

/// @nodoc
class __$$ConnectionModelImplCopyWithImpl<$Res>
    extends _$ConnectionModelCopyWithImpl<$Res, _$ConnectionModelImpl>
    implements _$$ConnectionModelImplCopyWith<$Res> {
  __$$ConnectionModelImplCopyWithImpl(
      _$ConnectionModelImpl _value, $Res Function(_$ConnectionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectedAt = null,
    Object? userId = null,
    Object? connectionUserId = null,
    Object? connectionStatus = null,
    Object? connectionPostId = freezed,
    Object? connectionLocation = freezed,
  }) {
    return _then(_$ConnectionModelImpl(
      connectedAt: null == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      connectionUserId: null == connectionUserId
          ? _value.connectionUserId
          : connectionUserId // ignore: cast_nullable_to_non_nullable
              as String,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
      connectionPostId: freezed == connectionPostId
          ? _value.connectionPostId
          : connectionPostId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectionLocation: freezed == connectionLocation
          ? _value.connectionLocation
          : connectionLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionModelImpl implements _ConnectionModel {
  const _$ConnectionModelImpl(
      {required this.connectedAt,
      required this.userId,
      required this.connectionUserId,
      required this.connectionStatus,
      this.connectionPostId,
      this.connectionLocation});

  factory _$ConnectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionModelImplFromJson(json);

  @override
  final DateTime connectedAt;
  @override
  final String userId;
  @override
  final String connectionUserId;
  @override
  final ConnectionStatus connectionStatus;
  @override
  final String? connectionPostId;
  @override
  final String? connectionLocation;

  @override
  String toString() {
    return 'ConnectionModel(connectedAt: $connectedAt, userId: $userId, connectionUserId: $connectionUserId, connectionStatus: $connectionStatus, connectionPostId: $connectionPostId, connectionLocation: $connectionLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionModelImpl &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.connectionUserId, connectionUserId) ||
                other.connectionUserId == connectionUserId) &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.connectionPostId, connectionPostId) ||
                other.connectionPostId == connectionPostId) &&
            (identical(other.connectionLocation, connectionLocation) ||
                other.connectionLocation == connectionLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, connectedAt, userId,
      connectionUserId, connectionStatus, connectionPostId, connectionLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionModelImplCopyWith<_$ConnectionModelImpl> get copyWith =>
      __$$ConnectionModelImplCopyWithImpl<_$ConnectionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionModelImplToJson(
      this,
    );
  }
}

abstract class _ConnectionModel implements ConnectionModel {
  const factory _ConnectionModel(
      {required final DateTime connectedAt,
      required final String userId,
      required final String connectionUserId,
      required final ConnectionStatus connectionStatus,
      final String? connectionPostId,
      final String? connectionLocation}) = _$ConnectionModelImpl;

  factory _ConnectionModel.fromJson(Map<String, dynamic> json) =
      _$ConnectionModelImpl.fromJson;

  @override
  DateTime get connectedAt;
  @override
  String get userId;
  @override
  String get connectionUserId;
  @override
  ConnectionStatus get connectionStatus;
  @override
  String? get connectionPostId;
  @override
  String? get connectionLocation;
  @override
  @JsonKey(ignore: true)
  _$$ConnectionModelImplCopyWith<_$ConnectionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
