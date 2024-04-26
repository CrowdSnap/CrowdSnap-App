import 'package:shared_preferences/shared_preferences.dart';

class StoreAuth {
  static const _authStatusKey = 'auth_status';

  Future<void> setAuthStatus(AuthStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_authStatusKey, status.index);
  }

  Future<AuthStatus> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusIndex = prefs.getInt(_authStatusKey) ?? 0;
    return AuthStatus.values[statusIndex];
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
    }
    return isFirstLaunch;
  }
}

enum AuthStatus {
  avatarUpload,
  googleSignUp,
  loggedIn,
  loggedOut,
}
