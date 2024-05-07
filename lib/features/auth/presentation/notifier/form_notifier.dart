import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_notifier.g.dart';

// Clase `FormState` que representa el estado de un formulario de registro o inicio de sesión de usuario en su aplicación.
class FormState {
  final String name;
  final String email;
  final String password;
  final String userName;
  final DateTime? birthDate;
  final bool showPassword;
  final bool isPasswordValid;
  final bool isBirthDateValid;
  final bool isLoading;
  final bool isLoadingGoogle;

  // Constructor para crear una nueva instancia de `FormState`.
  //
  // - `name`: Nombre completo del usuario (opcional, por defecto cadena vacía).
  // - `email`: Dirección de correo electrónico del usuario (opcional, por defecto cadena vacía).
  // - `password`: Contraseña del usuario (opcional, por defecto cadena vacía).
  // - `userName`: Nombre de usuario del usuario (opcional, por defecto cadena vacía).
  // - `birthDate`: Fecha de nacimiento del usuario (opcional, por defecto `null`).
  // - `showPassword`: Bandera para mostrar la contraseña (opcional, por defecto `false`).
  // - `isPasswordValid`: Bandera para indicar la validez de la contraseña (opcional, por defecto `false`).
  // - `isBirthDateValid`: Bandera para indicar la validez de la fecha de nacimiento (opcional, por defecto `false`).
  // - `isLoading`: Bandera para indicar si el formulario está cargando (opcional, por defecto `false`).
  // - `isLoadingGoogle`: Bandera para indicar si se está cargando un registro o inicio de sesión con Google (opcional, por defecto `false`).
  FormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.userName = '',
    this.birthDate,
    this.showPassword = false,
    this.isPasswordValid = false,
    this.isLoading = false,
    this.isLoadingGoogle = false,
    this.isBirthDateValid = false,
  });

  // Método para crear una copia del estado actual de `FormState` con la posibilidad de actualizar propiedades específicas.
  //
  // - `name`: Nombre completo del usuario (opcional, valor actual si no se especifica).
  // - `email`: Dirección de correo electrónico del usuario (opcional, valor actual si no se especifica).
  // - `password`: Contraseña del usuario (opcional, valor actual si no se especifica).
  // - `userName`: Nombre de usuario del usuario (opcional, valor actual si no se especifica).
  // - `birthDate`: Fecha de nacimiento del usuario (opcional, valor actual si no se especifica).
  // - `showPassword`: Bandera para mostrar la contraseña (opcional, valor actual si no se especifica).
  // - `isPasswordValid`: Bandera para indicar la validez de la contraseña (opcional, valor actual si no se especifica).
  // - `isBirthDateValid`: Bandera para indicar la validez de la fecha de nacimiento (opcional, valor actual si no se especifica).
  // - `isLoading`: Bandera para indicar si el formulario está cargando (opcional, valor actual si no se especifica).
  // - `isLoadingGoogle`: Bandera para indicar si se está cargando un registro o inicio de sesión con Google (opcional, valor actual si no se especifica).
  FormState copyWith({
    String? name,
    String? email,
    String? password,
    String? userName,
    DateTime? birthDate,
    bool? showPassword,
    bool? isPasswordValid,
    bool? isBirthDateValid,
    bool? isLoading,
    bool? isLoadingGoogle,
  }) {
    return FormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      birthDate: birthDate ?? this.birthDate,
      showPassword: showPassword ?? this.showPassword,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
      isLoading: isLoading ?? this.isLoading,
      isLoadingGoogle: isLoadingGoogle ?? this.isLoadingGoogle,
    );
  }
}

// Clase `FormNotifier` derivada de `_$FormNotifier` que gestiona el estado y la lógica para los formularios de registro e inicio de sesión de usuarios dentro de su aplicación Riverpod.
@riverpod
class FormNotifier extends _$FormNotifier {
  // Método que establece el estado inicial a un objeto `FormState` vacío.
  @override
  FormState build() {
    return FormState();
  }

  // Método para actualizar el estado del formulario con el valor `nombre` (nombre) proporcionado.
  void updateNombre(String nombre) {
    state = state.copyWith(name: nombre);
  }

  // Método para actualizar el estado del formulario con el valor `email` proporcionado.
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// Método para actualizar el estado del formulario con el valor `password` proporcionado.
  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  // Método para actualizar el estado del formulario con el valor `userName` proporcionado.
  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  // Método para actualizar el estado del formulario con la fecha de nacimiento proporcionada.
  void updateBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  // Método para restablecer el estado del formulario a su estado inicial.
  void reset() {
    state = FormState();
  }

  // Método para alternar la visibilidad de la contraseña en el formulario.
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  // Método para iniciar la carga de un registro o inicio de sesión con Google.
  void startGoogleLoading() {
    state = state.copyWith(isLoadingGoogle: true);
  }

  // Método para detener la carga de un registro o inicio de sesión con Google.
  void stopGoogleLoading() {
    state = state.copyWith(isLoadingGoogle: false);
  }

  // Método para iniciar la carga del formulario.
  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  // Método para detener la carga del formulario.
  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }

  // Método para obtener el icono de la contraseña en función de si se muestra o no.
  IconData getPasswordIcon() {
    return state.showPassword ? Icons.visibility : Icons.visibility_off;
  }

  // Método que realiza una validación visual de la contraseña en función de los criterios definidos (al menos 6 caracteres, que incluyen mayúsculas, minúsculas, números y caracteres especiales). Actualiza la bandera `isPasswordValid` en el estado del formulario.
  void validatePasswordVisual() {
    final password = state.password;
    bool isValid = password.length >= 6 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    state = state.copyWith(isPasswordValid: isValid);
  }

  // Método que realiza una validación visual de la fecha de nacimiento, comprobando si el usuario tiene al menos 18 años. Actualiza la bandera `isBirthDateValid` en el estado del formulario.
  void validateBirthDateVisual() {
    final now = DateTime.now();
    final age = now.year - state.birthDate!.year;
    if (state.birthDate!.month > now.month ||
        (state.birthDate!.month == now.month &&
            state.birthDate!.day > now.day)) {
      state = state.copyWith(isBirthDateValid: age > 18);
    } else {
      state = state.copyWith(isBirthDateValid: age >= 18);
    }
  }
}
