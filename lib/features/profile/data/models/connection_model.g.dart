// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectionModelImpl _$$ConnectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionModelImpl(
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      userId: json['userId'] as String,
      connectionUserId: json['connectionUserId'] as String,
      connectionPostId: json['connectionPostId'] as String?,
      connectionLocation: json['connectionLocation'] as String?,
    );

Map<String, dynamic> _$$ConnectionModelImplToJson(
        _$ConnectionModelImpl instance) =>
    <String, dynamic>{
      'connectedAt': instance.connectedAt.toIso8601String(),
      'userId': instance.userId,
      'connectionUserId': instance.connectionUserId,
      'connectionPostId': instance.connectionPostId,
      'connectionLocation': instance.connectionLocation,
    };
