import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/list_extension.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit_2.0/app_colors.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';
import '../../domain/entities/theme_setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String preloadValue = PreloadWeeks.oneWeek.title;
  String storeValue = StoreWeeks.oneMonth.title;

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
          _buildDropdownRow(
            context,
            label: 'Подгружать расписание вперед на:',
            value: preloadValue,
            items: PreloadWeeks.values.map((e) => e.title).toList(),
            onChanged: (v) => setState(() => preloadValue = v!),
            textStyles: textStyles,
          ),
          const SizedBox(height: 8),

          _buildDropdownRow(
            context,
            label: 'Хранить расписание в течение:',
            value: storeValue,
            items: StoreWeeks.values.map((e) => e.title).toList(),
            onChanged: (v) => setState(() => storeValue = v!),
            textStyles: textStyles,
          ),

          const SizedBox(height: 56),

          // -------------------- ВЫБОР ТЕМЫ --------------------
          Text(
            'Выбор темы интерфейса',
            style: textStyles.settingsPageSectionTitle,
          ),
          const SizedBox(height: 24),

          ..._buildThemeRows(context, textStyles),
        ],
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

  List<Widget> _buildThemeRows(BuildContext context, AppTypography textStyles) {
    final List<List<ThemeSetting>> dividedLists = themeSettings.chunk(7);
    return dividedLists.map((row) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              row.map((setting) {
                final isSelected = selectedSetting == setting;
                final innerColor =
                    setting.isLightTheme
                        ? NewAppColors.bgLight
                        : NewAppColors.bgDark;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedSetting = setting);
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
