// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectionModelImpl _$$ConnectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionModelImpl(
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      connectionStatus:
          $enumDecode(_$ConnectionStatusEnumMap, json['connectionStatus']),
      connectionPostId: json['connectionPostId'] as String?,
      connectionLocation: json['connectionLocation'] as String?,
    );

Map<String, dynamic> _$$ConnectionModelImplToJson(
        _$ConnectionModelImpl instance) =>
    <String, dynamic>{
      'connectedAt': instance.connectedAt.toIso8601String(),
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'connectionStatus': _$ConnectionStatusEnumMap[instance.connectionStatus]!,
      'connectionPostId': instance.connectionPostId,
      'connectionLocation': instance.connectionLocation,
    };

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.connected: 'connected',
  ConnectionStatus.pending: 'pending',
  ConnectionStatus.taggingRequest: 'taggingRequest',
  ConnectionStatus.waitingForAcceptance: 'waitingForAcceptance',
  ConnectionStatus.rejected: 'rejected',
  ConnectionStatus.none: 'none',
};
