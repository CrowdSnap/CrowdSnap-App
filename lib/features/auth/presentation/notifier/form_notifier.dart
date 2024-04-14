import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_notifier.g.dart';

class FormState {
  final String nombre;
  final String email;
  final String password;
  final String userName;
  final bool showPassword;
  final bool isPasswordValid;

  FormState(
      {this.nombre = '',
      this.email = '',
      this.password = '',
      this.userName = '',
      this.showPassword = false,
      this.isPasswordValid = false});

  FormState copyWith({
    String? nombre,
    String? email,
    String? password,
    String? userName,
    bool? showPassword,
    bool? isPasswordValid,
  }) {
    return FormState(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      showPassword: showPassword ?? this.showPassword,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}

@riverpod
class FormNotifier extends _$FormNotifier {
  @override
  FormState build() {
    return FormState();
  }

  void updateNombre(String nombre) {
    state = state.copyWith(nombre: nombre);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  void reset() {
    state = FormState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  IconData getPasswordIcon() {
    return state.showPassword ? Icons.visibility : Icons.visibility_off;
  }

  void validatePasswordVisual() {
    final password = state.password;
    bool isValid = password.length >= 6 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    state = state.copyWith(isPasswordValid: isValid);
  }

  InputBorder getBorder(BuildContext context, {bool isError = false}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  if (state.password.isEmpty) {
    return theme.inputDecorationTheme.enabledBorder ?? 
      UnderlineInputBorder(
        borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.38)),
      );
  } else if (isError || !state.isPasswordValid) {
    return theme.inputDecorationTheme.errorBorder ?? 
      UnderlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error),
      );
  } else {
    return theme.inputDecorationTheme.focusedBorder ?? 
      UnderlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
      );
  }
}

}
