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
  final int age;
  final String userName;
  final bool isLoading;
  final String googleImage;
  final String userImage;

  GoogleSignUpState(
      {this.name = '',
      this.email = '',
      this.age = 0,
      this.userName = '',
      this.isLoading = false,
      this.googleImage = '',
      this.userImage = '',});

  GoogleSignUpState copyWith({
    String? name,
    String? email,
    int? age,
    String? userName,
    bool? isLoading,
    String? googleImage,
    String? userImage,
  }) {
    return GoogleSignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
      googleImage: googleImage ?? this.googleImage,
      userImage: userImage ?? this.userImage,
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

  void updateAge(int age) {
    state = state.copyWith(age: age);
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

  void reset() {
    state = GoogleSignUpState();
  }
}
