import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/settings_usecases/saved_theme.dart';
import '../../../domain/usecases/settings_usecases/update_constraints.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetLoadingConstraints getLoading;
  final GetKeepingConstraints getKeeping;
  final GetSavedTheme getSavedTheme;
  final UpdateLoadingConstraints updateLoading;
  final UpdateKeepingConstraints updateKeeping;
  final SetSavedTheme setSavedTheme;

  SettingsBloc({
    required this.getLoading,
    required this.getKeeping,
    required this.getSavedTheme,
    required this.updateLoading,
    required this.updateKeeping,
    required this.setSavedTheme,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateLoadingConstraintsEvent>(_onUpdateLoading);
    on<UpdateKeepingConstraintsEvent>(_onUpdateKeeping);
    on<UpdateAppThemeEvent>(_onUpdateTheme);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final loadingParams = await getLoading();
      final keepingParams = await getKeeping();
      final theme = await getSavedTheme();

      emit(
        SettingsLoaded(
          preloadWeeks: loadingParams.numOfWeeks,
          storeWeeks: keepingParams.numOfWeeks,
          selectedTheme: theme,
        ),
      );
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLoading(
    UpdateLoadingConstraintsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      await updateLoading(
        UpdateConstraintsParams(numOfWeeks: event.numOfWeeks),
      );
      // После успешного обновления — загрузим текущие значения из репозитория
      final loadingParams = await getLoading();
      final state = this.state;
      if (state is SettingsLoaded) {
        emit(state.copyWith(preloadWeeks: loadingParams.numOfWeeks));
      } else {
        final keepingParams = await getKeeping();
        final theme = await getSavedTheme();

        emit(
          SettingsLoaded(
            preloadWeeks: loadingParams.numOfWeeks,
            storeWeeks: keepingParams.numOfWeeks,
            selectedTheme: theme,
          ),
        );
      }
    } catch (e) {
      // можно вернуть prev либо SettingsError
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateKeeping(
    UpdateKeepingConstraintsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      await updateKeeping(
        UpdateConstraintsParams(numOfWeeks: event.numOfWeeks),
      );
      final keepingParams = await getKeeping();
      final state = this.state;
      if (state is SettingsLoaded) {
        emit(state.copyWith(storeWeeks: keepingParams.numOfWeeks));
      } else {
        final loadingParams = await getLoading();
        final theme = await getSavedTheme();
        emit(
          SettingsLoaded(
            preloadWeeks: loadingParams.numOfWeeks,
            storeWeeks: keepingParams.numOfWeeks,
            selectedTheme: theme,
          ),
        );
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTheme(
    UpdateAppThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // сохраняем новую тему и затем возвращаем обновлённый SettingsLoaded
    emit(SettingsLoading());
    try {
      await setSavedTheme(
        SetSavedThemeParams(newTheme: event.themeSetting),
      );
      final loadingParams = await getLoading();
      final keepingParams = await getKeeping();
      final theme = await getSavedTheme();

      emit(
        SettingsLoaded(
          preloadWeeks: loadingParams.numOfWeeks,
          storeWeeks: keepingParams.numOfWeeks,
          selectedTheme: theme,
        ),
      );
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}
