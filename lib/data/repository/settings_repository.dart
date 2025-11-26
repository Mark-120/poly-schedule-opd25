import 'package:hive/hive.dart';

import '../../domain/entities/theme_setting.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  Box settings;
  SettingsRepositoryImpl({required this.settings});
  static const themeKey = 'Theme';
  static const keepingKey = 'KeepingConstraint';
  static const loadingKey = 'LoadingConstraint';

  @override
  Future<ThemeSetting?> getSavedTheme() {
    return settings.get(themeKey);
  }

  @override
  Future<void> setSavedTheme(ThemeSetting newTheme) {
    return settings.put(themeKey, newTheme);
  }

  @override
  Future<void> updateKeepingConstraints(int numOfWeeks) {
    return settings.put(keepingKey, numOfWeeks);
  }

  @override
  Future<void> updateLoadingConstraints(int numOfWeeks) {
    return settings.put(loadingKey, numOfWeeks);
  }

  @override
  Future<int> getKeepingConstraints() async {
    return settings.get(keepingKey) ?? 1;
  }

  @override
  Future<int> getLoadingConstraints() async {
    return settings.get(loadingKey) ?? 4;
  }
}
