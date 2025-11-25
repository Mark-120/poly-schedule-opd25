import 'package:hive/hive.dart';

import '../../domain/entities/theme_setting.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  Box settings;
  SettingsRepositoryImpl({required this.settings});
  static const themeKey = 'Theme';

  @override
  Future<ThemeSetting> getSavedTheme() {
    return settings.get(themeKey);
  }

  @override
  Future<void> setSavedTheme(ThemeSetting newTheme) {
    return settings.put(themeKey, newTheme);
  }
}
