import '../../../domain/entities/theme_setting.dart';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateLoadingConstraintsEvent extends SettingsEvent {
  final int numOfWeeks;
  UpdateLoadingConstraintsEvent(this.numOfWeeks);
}

class UpdateKeepingConstraintsEvent extends SettingsEvent {
  final int numOfWeeks;
  UpdateKeepingConstraintsEvent(this.numOfWeeks);
}

class UpdateAppThemeEvent extends SettingsEvent {
  final ThemeSetting themeSetting;
  UpdateAppThemeEvent(this.themeSetting);
}
