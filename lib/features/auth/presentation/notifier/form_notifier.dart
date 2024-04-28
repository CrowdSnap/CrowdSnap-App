import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_notifier.g.dart';

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

@riverpod
class FormNotifier extends _$FormNotifier {
  @override
  FormState build() {
    return FormState();
  }

  void updateNombre(String nombre) {
    state = state.copyWith(name: nombre);
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

  void updateBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void reset() {
    state = FormState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void startGoogleLoading() {
    state = state.copyWith(isLoadingGoogle: true);
  }

  void stopGoogleLoading() {
    state = state.copyWith(isLoadingGoogle: false);
  }

  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
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
