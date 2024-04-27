import 'package:crowd_snap/core/data/models/google_user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/google_user_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_sign_up_notifier.g.dart';

@riverpod
Future<GoogleUserModel> googleUser(GoogleUserRef ref) async {
  final repository = ref.watch(googleUserRepositoryProvider);
  return await repository.getGoogleUser();
}

class GoogleSignUpState {
  final String name;
  final String email;
  final DateTime? birthDate;
  final String userName;
  final bool isLoading;
  final String googleImage;
  final String userImage;
  final bool isBirthDateValid;

  GoogleSignUpState({
    this.name = '',
    this.email = '',
    this.birthDate,
    this.userName = '',
    this.isLoading = false,
    this.googleImage = '',
    this.userImage = '',
    this.isBirthDateValid = false,
  });

  GoogleSignUpState copyWith({
    String? name,
    String? email,
    DateTime? birthDate,
    String? userName,
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
      isLoading: isLoading ?? this.isLoading,
      googleImage: googleImage ?? this.googleImage,
      userImage: userImage ?? this.userImage,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
    );
  }
}

@riverpod
class GoogleSignUpNotifier extends _$GoogleSignUpNotifier {
  @override
  GoogleSignUpState build() {
    return GoogleSignUpState();
  }

  Future<void> initialize() async {
    try {
      final googleUser = await ref.watch(googleUserProvider.future);
      state = GoogleSignUpState(
        name: googleUser.name ?? '',
        email: googleUser.email ?? '',
        userName: googleUser.email?.split('@').first ?? '',
        googleImage: googleUser.avatarUrl ?? '',
      );
    } catch (e) {
      print('Error initializing Google User: $e');
    }
  }

  void updateNombre(String nombre) {
    state = state.copyWith(name: nombre);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void updateUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  void updateGoogleImage(String googleImage) {
    state = state.copyWith(googleImage: googleImage);
  }

  void updateUserImage(String userImage) {
    state = state.copyWith(userImage: userImage);
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
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

  void reset() {
    state = GoogleSignUpState();
  }
}
