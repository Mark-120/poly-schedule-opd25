import '../../../common/usecases/usecase.dart';
import '../../../core/presentation/uikit_2.0/app_colors.dart';
import '../../entities/theme_setting.dart';
import '../../repositories/settings_repository.dart';

class UpdateThemeSettingsConstraints implements UseCase<void, ThemeSetting> {
  final SettingsRepository repository;

  UpdateThemeSettingsConstraints(this.repository);

  @override
  Future<void> call(ThemeSetting params) {
    return repository.setSavedTheme(params);
  }
}

class GetThemeSettingsConstraints {
  final SettingsRepository repository;

  GetThemeSettingsConstraints(this.repository);

  Future<ThemeSetting> call() {
    return repository.getSavedTheme().then(
      (x) => x ?? ThemeSetting(color: NewAppColors.Ryae, isLightTheme: true),
    );
  }
}
