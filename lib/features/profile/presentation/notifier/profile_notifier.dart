import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

class ProfileState {
  final String userId;
  final String name;
  final String email;
  final String userName;
  final int age;
  final File? image;

  ProfileState(
      {this.userId = '',
      this.name = '',
      this.email = '',
      this.userName = '',
      this.age = 0,
      this.image});

  ProfileState copyWith({
    String? userId,
    String? name,
    String? email,
    String? userName,
    int? age,
    File? image,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      image: image ?? this.image,
    );
  }
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    return ProfileState();
  }

  void updateUserId(String userId) {
    state = state.copyWith(userId: userId);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void updateImage(File image) {
    state = state.copyWith(image: image);
  }
}
