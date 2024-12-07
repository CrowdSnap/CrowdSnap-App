import 'package:flutter/foundation.dart';
import 'dart:html' as ui;
import 'package:path_provider/path_provider.dart';

abstract class StorageService {
  Future<String?> getAvatar(String userId);
  Future<void> saveAvatar(String userId, String avatarData);
}

class MobileStorageService implements StorageService {
  @override
  Future<String?> getAvatar(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    // implementación existente para móvil
  }

  @override
  Future<void> saveAvatar(String userId, String avatarData) async {
    final directory = await getApplicationDocumentsDirectory();
    // implementación existente para móvil
  }
}

class WebStorageService implements StorageService {
  @override
  Future<String?> getAvatar(String userId) async {
    if (kIsWeb) {
      try {
        // ignore: undefined_prefixed_name
        return ui.window.localStorage['avatar_$userId'];
      } catch (e) {
        debugPrint('Error accessing localStorage: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveAvatar(String userId, String avatarData) async {
    if (kIsWeb) {
      try {
        // ignore: undefined_prefixed_name
        ui.window.localStorage['avatar_$userId'] = avatarData;
      } catch (e) {
        debugPrint('Error saving to localStorage: $e');
      }
    }
  }
}