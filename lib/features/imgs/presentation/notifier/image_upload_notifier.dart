import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload_notifier.g.dart';

class ImageUploadState {
  final bool isLoading;

  ImageUploadState({this.isLoading = false});

  ImageUploadState copyWith({bool? isLoading}) {
    return ImageUploadState(isLoading: isLoading ?? this.isLoading);
  }
}

@riverpod
class ImageUploadNotifier extends _$ImageUploadNotifier {
  @override
  ImageUploadState build() {
    return ImageUploadState();
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}