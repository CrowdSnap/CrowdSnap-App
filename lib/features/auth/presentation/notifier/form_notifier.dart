import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_notifier.g.dart';

class FormState {
  final String name;
  final String email;
  final String password;
  final String userName;
  final int age;
  final bool showPassword;
  final bool isPasswordValid;
  final bool isAgeValid;
  final bool isLoading;

  FormState(
      {this.name = '',
      this.email = '',
      this.password = '',
      this.userName = '',
      this.age = 0,
      this.showPassword = false,
      this.isPasswordValid = false,
      this.isAgeValid = false,
      this.isLoading = false});

  FormState copyWith({
    String? name,
    String? email,
    String? password,
    String? userName,
    int? age,
    bool? showPassword,
    bool? isPasswordValid,
    bool? isAgeValid,
    bool? isLoading,
  }) {
    return FormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      showPassword: showPassword ?? this.showPassword,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isAgeValid: isAgeValid ?? this.isAgeValid,
      isLoading: isLoading ?? this.isLoading,
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

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void reset() {
    state = FormState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
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

  void validateAgeVisual() {
    state = state.copyWith(isAgeValid: state.age >= 18);
  }
}
