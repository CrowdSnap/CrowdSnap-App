import 'package:crowd_snap/features/profile/data/models/connection_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_model.freezed.dart';
part 'connection_model.g.dart';

@freezed
class ConnectionModel with _$ConnectionModel {
  const factory ConnectionModel({
    required DateTime connectedAt,
    required String senderId,
    required String receiverId,
    required ConnectionStatus connectionStatus,
    String? postId,
    String? imageUrl,
    String? connectionLocation,
  }) = _ConnectionModel;

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionModelFromJson(json);
}

ConnectionModel createConnectionModel(Map<String, dynamic> json) {
  return ConnectionModel(
    connectedAt: DateTime.parse(json['connectedAt'] as String),
    senderId:
        json['senderId'] as String, // Asegúrate de que este campo esté presente
    receiverId: json['receiverId']
        as String, // Asegúrate de que este campo esté presente
    connectionStatus:
        ConnectionStatusExtension.fromValue(json['status'] as String),
    postId: json['postId'] as String?,
    imageUrl: json['imageUrl'] as String?,
    connectionLocation: json['connectionLocation'] as String?,
  );
}
