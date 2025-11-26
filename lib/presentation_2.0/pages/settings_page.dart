import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/extensions/list_extension.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit_2.0/app_colors.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../domain/entities/theme_setting.dart';
import '../../service_locator.dart';
import '../state_managers/settings_bloc/settings_bloc.dart';
import '../state_managers/settings_bloc/settings_event.dart';
import '../state_managers/settings_bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupAppBar();
  }

  void _setupAppBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final textStyles = Theme.of(context).extension<AppTypography>()!;
      context.read<ScaffoldUiStateController>().update(
        ScaffoldUiState(
          appBar: AppBar(
            title: Text('Настройки', style: textStyles.appBarTitle),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return BlocProvider<SettingsBloc>(
      create: (_) => sl<SettingsBloc>()..add(LoadSettings()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          if (state is SettingsLoaded) {
            final preloadWeeks = state.preloadWeeks;
            final storeWeeks = state.storeWeeks;
            final selectedTheme = state.selectedTheme;

            final preloadValue = _preloadTitleFromWeeks(preloadWeeks);
            final storeValue = _storeTitleFromWeeks(storeWeeks);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------- ХРАНЕНИЕ РАСПИСАНИЯ --------------------
                  Text(
                    'Хранение расписания',
                    style: textStyles.settingsPageSectionTitle,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Подгружать расписание вперед на:',
                          style: textStyles.settingsPageItem,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildStyledDropdown(
                        value: preloadValue,
                        items: PreloadWeeks.values.map((e) => e.title).toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          final enumValue = PreloadWeeks.values.firstWhere(
                            (e) => e.title == v,
                          );
                          context.read<SettingsBloc>().add(
                            UpdateLoadingConstraintsEvent(enumValue.weeks),
                          );
                        },
                        textStyles: textStyles,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Хранить расписание в течение:',
                          style: textStyles.settingsPageItem,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildStyledDropdown(
                        value: storeValue,
                        items: StoreWeeks.values.map((e) => e.title).toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          final enumValue = StoreWeeks.values.firstWhere(
                            (e) => e.title == v,
                          );
                          context.read<SettingsBloc>().add(
                            UpdateKeepingConstraintsEvent(enumValue.weeks),
                          );
                        },
                        textStyles: textStyles,
                      ),
                    ],
                  ),

                  const SizedBox(height: 56),

                  // -------------------- ВЫБОР ТЕМЫ --------------------
                  Text(
                    'Выбор темы интерфейса',
                    style: textStyles.settingsPageSectionTitle,
                  ),
                  const SizedBox(height: 24),

                  ..._buildThemeRows(context, textStyles, selectedTheme),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDropdownRow(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required AppTypography textStyles,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: textStyles.settingsPageItem)),
        const SizedBox(width: 12),
        DropdownButton<String>(
          dropdownColor: NewAppColors.white,
          value: value,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyles.settingsPageItem),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // -------------------- THEME SELECTOR --------------------

  ThemeSetting? selectedSetting;

  Widget _buildStyledDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required AppTypography textStyles,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // полу-круги
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuWidth: 112,
          value: value,
          // icon: const Icon(Icons.add), // ← ИКОНКА ПЛЮСА
          isDense: true,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyles.settingsPageItem),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _buildThemeRows(
    BuildContext context,
    AppTypography textStyles,
    ThemeSetting? active,
  ) {
    final List<List<ThemeSetting>> dividedLists = themeSettings.chunk(7);
    return dividedLists.map((row) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              row.map((setting) {
                final isSelected = active == setting;
                final innerColor =
                    setting.isLightTheme
                        ? NewAppColors.bgLight
                        : NewAppColors.bgDark;

                return GestureDetector(
                  onTap: () {
                    context.read<SettingsBloc>().add(
                      UpdateAppThemeEvent(setting),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: setting.color,
                    ),
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: innerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: isSelected ? 24 : 28,
                            height: isSelected ? 24 : 28,
                            decoration: BoxDecoration(
                              color: setting.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: isSelected ? 12 : 16,
                                height: isSelected ? 12 : 16,
                                decoration: BoxDecoration(
                                  color: innerColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    }).toList();
  }
}

String _preloadTitleFromWeeks(int weeks) {
  final found = PreloadWeeks.values.firstWhere(
    (e) => e.weeks == weeks,
    orElse: () => PreloadWeeks.oneWeek,
  );
  return found.title;
}

String _storeTitleFromWeeks(int weeks) {
  final found = StoreWeeks.values.firstWhere(
    (e) => e.weeks == weeks,
    orElse: () => StoreWeeks.oneMonth,
  );
  return found.title;
}

enum PreloadWeeks {
  oneWeek('1 неделя', 1),
  twoWeeks('2 недели', 2),
  oneMonth('1 месяц', 4),
  twoMonths('2 месяца', 8),
  threeMonths('3 месяца', 12);

  final String title;
  final int weeks;

  const PreloadWeeks(this.title, this.weeks);
}

enum StoreWeeks {
  oneMonth('1 месяц', 4),
  twoMonths('2 месяца', 8),
  threeMonths('3 месяца', 12),
  sixMonths('6 месяцев', 24);

  final String title;
  final int weeks;

  const StoreWeeks(this.title, this.weeks);
}

// Использование:
final List<ThemeSetting> themeSettings = [
  ThemeSetting(color: NewAppColors.Vshmop, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ie, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Gi, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ifksit, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ryae, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ibsib, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ispo, isLightTheme: true),

  ThemeSetting(color: NewAppColors.Vshmop, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ie, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Gi, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ifksit, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ryae, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ibsib, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ispo, isLightTheme: false),

  ThemeSetting(color: NewAppColors.Fmi, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ipmeit, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Iknik, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ifim, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Immit, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ieit, isLightTheme: true),
  ThemeSetting(color: NewAppColors.Ici, isLightTheme: true),

  ThemeSetting(color: NewAppColors.Fmi, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ipmeit, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Iknik, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ifim, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Immit, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ieit, isLightTheme: false),
  ThemeSetting(color: NewAppColors.Ici, isLightTheme: false),
];
