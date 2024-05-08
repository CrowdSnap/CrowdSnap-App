import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

class ProfileState {
  final String userId;
  final String name;
  final String email;
  final String userName;
  final DateTime? birthDate;
  final File? image;

  ProfileState(
      {this.userId = '',
      this.name = '',
      this.email = '',
      this.userName = '',
      this.birthDate,
      this.image});

  // Crea una copia del estado actual con las propiedades modificadas.
  ProfileState copyWith({
    String? userId,
    String? name,
    String? email,
    String? userName,
    DateTime? birthDate,
    File? image,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
    );
  }
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  // Constructor para el notificador de perfil.
  // Inicializa el estado con un `ProfileState` vacío.
  @override
  ProfileState build() {
    return ProfileState();
  }

  // Actualiza el identificador de usuario en el estado.
  void updateUserId(String userId) {
    state = state.copyWith(userId: userId);
  }

  // Actualiza el nombre del usuario en el estado.
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  // Actualiza la dirección de correo electrónico del usuario en el estado.
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  // Actualiza el nombre de usuario del usuario en el estado.
  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  // Actualiza la fecha de nacimiento del usuario en el estado.
  void updateAge(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  // Actualiza la imagen de perfil del usuario en el estado.
  void updateImage(File image) {
    state = state.copyWith(image: image);
  }
}
