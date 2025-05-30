import 'package:crowd_snap/features/auth/data/models/google_user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories/google_user_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_sign_up_notifier.g.dart';

// Función `googleUser` decorada con `@riverpod` que recupera información del usuario de Google de forma asincrónica.
@riverpod
Future<GoogleUserModel> googleUser(GoogleUserRef ref) async {
  // Obtiene el repositorio de usuarios de Google del provider `googleUserRepositoryProvider`.
  final repository = ref.watch(googleUserRepositoryProvider);

  // Llama al método `getGoogleUser` del repositorio para recuperar la información del usuario de Google de forma asincrónica.
  //
  // - Devuelve un `Future<GoogleUserModel>` que se resolverá a un objeto `GoogleUserModel` con los datos del usuario.
  return await repository.getGoogleUser();
}

// Clase `GoogleSignUpState` que representa el estado del formulario de registro de Google.
class GoogleSignUpState {
  final String name;
  final String email;
  final DateTime? birthDate;
  final String userName;
  final bool isUserNameValid;
  final bool userNamesExists;
  final bool isLoading;
  final String googleImage;
  final String userImage;
  final bool isBirthDateValid;

  // Constructor para crear una nueva instancia de `GoogleSignUpState`.
  //
  // - `name`: Nombre completo del usuario (opcional, valor por defecto cadena vacía).
  // - `email`: Dirección de correo electrónico del usuario (opcional, valor por defecto cadena vacía).
  // - `birthDate`: Fecha de nacimiento del usuario (opcional, valor por defecto `null`).
  // - `userName`: Nombre de usuario del usuario (opcional, valor por defecto construido a partir de la dirección de correo electrónico).
  // - `isLoading`: Bandera para indicar si el registro está en progreso (opcional, valor por defecto `false`).
  // - `googleImage`: URL a la imagen de perfil del usuario de Google (opcional, valor por defecto cadena vacía).
  // - `userImage`: URL a la imagen de perfil elegida por el usuario (opcional, valor por defecto cadena vacía).
  // - `isBirthDateValid`: Bandera para indicar si la fecha de nacimiento ingresada es válida (opcional, valor por defecto `false`).
  GoogleSignUpState({
    this.name = '',
    this.email = '',
    this.birthDate,
    this.userName = '',
    this.isUserNameValid = true,
    this.userNamesExists = false,
    this.isLoading = false,
    this.googleImage = '',
    this.userImage = '',
    this.isBirthDateValid = false,
  });

  // Método para crear una copia del estado actual de `GoogleSignUpState` con la posibilidad de actualizar propiedades específicas.
  //
  // - `name`: Nombre completo del usuario (opcional, valor actual si no se especifica).
  // - `email`: Dirección de correo electrónico del usuario (opcional, valor actual si no se especifica).
  // - `birthDate`: Fecha de nacimiento del usuario (opcional, valor actual si no se especifica).
  // - `userName`: Nombre de usuario del usuario (opcional, valor actual si no se especifica).
  // - `isLoading`: Bandera para indicar si el registro está en progreso (opcional, valor actual si no se especifica).
  // - `googleImage`: URL a la imagen de perfil del usuario de Google (opcional, valor actual si no se especifica).
  // - `userImage`: URL a la imagen de perfil elegida por el usuario (opcional, valor actual si no se especifica).
  // - `isBirthDateValid`: Bandera para indicar si la fecha de nacimiento ingresada es válida (opcional, valor actual si no se especifica)
  GoogleSignUpState copyWith({
    String? name,
    String? email,
    DateTime? birthDate,
    String? userName,
    bool? isUserNameValid,
    bool? userNamesExists,
    bool? isLoading,
    String? googleImage,
    String? userImage,
    bool? isBirthDateValid,
  }) {
    return GoogleSignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      userName: userName ?? this.userName,
      isUserNameValid: isUserNameValid ?? this.isUserNameValid,
      userNamesExists: userNamesExists ?? this.userNamesExists,
      isLoading: isLoading ?? this.isLoading,
      googleImage: googleImage ?? this.googleImage,
      userImage: userImage ?? this.userImage,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
    );
  }
}

// Clase `GoogleSignUpNotifier` que gestiona el estado y la lógica del registro de Google.
@riverpod
class GoogleSignUpNotifier extends _$GoogleSignUpNotifier {
  // Método que establece el estado inicial a un objeto `GoogleSignUpState` vacío.
  @override
  GoogleSignUpState build() {
    return GoogleSignUpState();
  }

  // Método asíncrono que inicializa el estado con información del usuario de Google.
  Future<void> initialize() async {
    try {
      // Obtiene el usuario de Google del provider `googleUserProvider.future`.
      final googleUser = await ref.watch(googleUserProvider.future);

      // Actualiza el estado con la información del usuario de Google (nombre, email, username a partir del email, imagen de perfil).
      state = GoogleSignUpState(
        name: googleUser.name ?? '',
        email: googleUser.email ?? '',
        userName: googleUser.email?.split('@').first ?? '',
        googleImage: googleUser.avatarUrl ?? '',
      );
    } catch (e) {
      // Imprime un mensaje de error si ocurre un problema al obtener la información del usuario de Google.
      print('Error initializing Google User: $e');
    }
  }

  // Método para actualizar el nombre del usuario en el estado.
  void updateNombre(String nombre) {
    state = state.copyWith(name: nombre);
  }

  // Método para actualizar el email del usuario en el estado.
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  // Método para actualizar la fecha de nacimiento del usuario en el estado.
  void updateBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  // Método para actualizar el nombre de usuario elegido por el usuario en el estado.
  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  void setUserNamesExists(bool exists) {
    state = state.copyWith(userNamesExists: exists);
  }

  // Método para actualizar la URL de la imagen de perfil de Google del usuario en el estado.
  void updateGoogleImage(String googleImage) {
    state = state.copyWith(googleImage: googleImage);
  }

  // Método para actualizar la URL de la imagen de perfil elegida por el usuario en el estado.
  void updateUserImage(String userImage) {
    state = state.copyWith(userImage: userImage);
  }

  // Método para actualizar la bandera de carga (`isLoading`) en el estado.
  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  // Método para realizar una validación visual de la fecha de nacimiento (debe ser mayor o igual a 18 años).
  void validateBirthDateVisual() {
    final now = DateTime.now();
    final age = now.year - state.birthDate!.year;
    if (state.birthDate!.month > now.month ||
        (state.birthDate!.month == now.month &&
            state.birthDate!.day > now.day)) {
      state = state.copyWith(isBirthDateValid: age > 16);
    } else {
      state = state.copyWith(isBirthDateValid: age >= 16);
    }
  }

  void validateUserNameVisual() {
    final userName = state.userName;
    final isValid = userName.isNotEmpty &&
        userName.length >= 3 &&
        userName.length <= 15 &&
        RegExp(r'^[a-z0-9_\-\.]*$').hasMatch(userName);
    print('isUserNameValid: $isValid');
    state = state.copyWith(isUserNameValid: isValid);
  }

  // Método para restablecer el estado a su valor inicial vacío.
  void reset() {
    state = GoogleSignUpState();
  }
}
