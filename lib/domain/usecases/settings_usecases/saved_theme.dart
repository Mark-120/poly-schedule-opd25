import '../../../common/usecases/usecase.dart';
import '../../entities/theme_setting.dart';
import '../../repositories/settings_repository.dart';

class GetSavedTheme {
  final SettingsRepository repository;

  GetSavedTheme(this.repository);

  Future<ThemeSetting> call() async {
    return await repository.getSavedTheme();
  }
}

class SetSavedTheme implements UseCase<void, SetSavedThemeParams> {
  final SettingsRepository repository;

  SetSavedTheme(this.repository);

  @override
  Future<void> call(SetSavedThemeParams params) async {
    return await repository.setSavedTheme(params.newTheme);
  }
}

class SetSavedThemeParams {
  final ThemeSetting newTheme;

  const SetSavedThemeParams({required this.newTheme});
}
