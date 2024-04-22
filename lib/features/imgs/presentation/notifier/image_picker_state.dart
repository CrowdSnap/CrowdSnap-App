import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker_state.g.dart';

@riverpod
class ImageState extends _$ImageState {
  @override
  File? build() => null;

  void setImage(File? image) {
    state = image;
  }
}

