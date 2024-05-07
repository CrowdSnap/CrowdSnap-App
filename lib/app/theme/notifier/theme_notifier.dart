import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

@riverpod
class DarkMode extends _$DarkMode {
  @override
  bool build() {
    // Get the current brightness mode of the device
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // Return true if dark mode, false if light mode
    return brightness == Brightness.dark;
  }

  void toggleDarkMode() {
    state = !state;
  }
}
