import 'dart:io';

import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

class ProfileState {
  final String userId;
  final String name;
  final String email;
  final String userName;
  final DateTime? birthDate;
  final File? image;
  final List<PostModel> posts;
  final int index;

  ProfileState(
      {this.userId = '',
      this.name = '',
      this.email = '',
      this.userName = '',
      this.birthDate,
      this.image,
      this.posts = const [],
      this.index = 0});

  // Crea una copia del estado actual con las propiedades modificadas.
  ProfileState copyWith({
    String? userId,
    String? name,
    String? email,
    String? userName,
    DateTime? birthDate,
    File? image,
    List<PostModel>? posts,
    int? index,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      posts: posts ?? this.posts,
      index: index ?? this.index,
    );
  }
}

@Riverpod(keepAlive: true)
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

  // Actualiza la lista de publicaciones del usuario en el estado.
  void updatePosts(List<PostModel> posts) {
    state = state.copyWith(posts: posts);
  }

  // Actualiza el índice de la grid seleccionada en el estado.
  void updateIndex(int index) {
    state = state.copyWith(index: index);
  }

  // Limpia el estado del notificador.
  void clear() {
    state = ProfileState();
  }
}
