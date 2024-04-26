import 'package:crowd_snap/app/router/redirect/shared_preferences/store_auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

final _prefsService = StoreAuth();

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<AuthStatus> build() async {
    final status = await _prefsService.getAuthStatus();
    
    final isFirstLaunch = await _prefsService.isFirstLaunch();
    
    if (isFirstLaunch) {
      // Si es la primera vez, establecer el estado inicial como loggedOut
      await _prefsService.setAuthStatus(AuthStatus.loggedOut);
      return AuthStatus.loggedOut;
    } else {
      // En el resto de los casos, seguir el AuthStatus que marque la aplicación
      return status;
    }
  }

  Future<void> loggedIn() async {
    await _prefsService.setAuthStatus(AuthStatus.loggedIn);
    state = await AsyncValue.guard(() => _prefsService.getAuthStatus());
  }

  Future<void> avatarUpload() async {
    await _prefsService.setAuthStatus(AuthStatus.avatarUpload);
    state = await AsyncValue.guard(() => _prefsService.getAuthStatus());
  }

  Future<void> loggedOut() async {
    await _prefsService.setAuthStatus(AuthStatus.loggedOut);  
    state = await AsyncValue.guard(() => _prefsService.getAuthStatus());
  }

  Future<void> googleSignUp() async {
    await _prefsService.setAuthStatus(AuthStatus.googleSignUp);
    state = await AsyncValue.guard(() => _prefsService.getAuthStatus());
  }
}
