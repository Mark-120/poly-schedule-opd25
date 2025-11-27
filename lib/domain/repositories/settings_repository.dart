import '../entities/theme_setting.dart';

abstract class SettingsRepository {
  const SettingsRepository();
  Future<ThemeSetting?> getSavedTheme();
  Future<void> setSavedTheme(ThemeSetting newTheme);

  Future<void> updateLoadingConstraints(int numOfWeeks);
  Future<void> updateKeepingConstraints(int numOfWeeks);

  Future<int> getKeepingConstraints();
  Future<int> getLoadingConstraints();
}
