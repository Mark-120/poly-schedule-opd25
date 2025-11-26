import '../../../domain/entities/theme_setting.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final int preloadWeeks;
  final int storeWeeks;
  final ThemeSetting selectedTheme;

  SettingsLoaded({
    required this.preloadWeeks,
    required this.storeWeeks,
    required this.selectedTheme,
  });

  SettingsLoaded copyWith({
    int? preloadWeeks,
    int? storeWeeks,
    ThemeSetting? selectedTheme,
  }) {
    return SettingsLoaded(
      preloadWeeks: preloadWeeks ?? this.preloadWeeks,
      storeWeeks: storeWeeks ?? this.storeWeeks,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError({required this.message});
}
