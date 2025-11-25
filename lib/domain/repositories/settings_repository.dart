import '../entities/theme_setting.dart';

abstract class SettingsRepository {
  const SettingsRepository();
  Future<ThemeSetting> getSavedTheme();
  Future<void> setSavedTheme(ThemeSetting newTheme);
}
