import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_model.freezed.dart';
part 'connection_model.g.dart';

@freezed
class ConnectionModel with _$ConnectionModel {
  const factory ConnectionModel({
    required DateTime connectedAt,
    required String userId,
    required String connectionUserId,
    String? connectionPostId,
    String? connectionLocation,
  }) = _ConnectionModel;

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionModelFromJson(json);
}