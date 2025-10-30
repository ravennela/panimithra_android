import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial());

  void setThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        emit(const ThemeLight());
      case ThemeMode.dark:
        emit(const ThemeDark());
      case ThemeMode.system:
        emit(const ThemeInitial());
    }
  }
  
  void toggleTheme() {
    if (state is ThemeLight) {
      emit(const ThemeDark());
    } else {
      emit(const ThemeLight());
    }
  }

  ThemeMode get currentThemeMode => state.themeMode;
}
