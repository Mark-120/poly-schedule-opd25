import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';
import '../../domain/entities/theme_setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String preloadValue = '1 неделя';
  String storeValue = '1 месяц';

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
    final themeColors = Theme.of(context).extension<ThemeColors>()!;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // -------------------- ХРАНЕНИЕ РАСПИСАНИЯ --------------------
          Text(
            'Хранение расписания',
            style: textStyles.settingsPageSectionTitle,
          ),
          const SizedBox(height: 12),

          _buildDropdownRow(
            context,
            label: 'Подгружать расписание вперед на:',
            value: preloadValue,
            items: const [
              '1 неделя',
              '2 недели',
              '1 месяц',
              '2 месяца',
              '3 месяца',
            ],
            onChanged: (v) => setState(() => preloadValue = v!),
            textStyles: textStyles,
          ),
          const SizedBox(height: 12),

          _buildDropdownRow(
            context,
            label: 'Хранить расписание в течение:',
            value: storeValue,
            items: const ['1 месяц', '2 месяца', '3 месяца', '6 месяцев'],
            onChanged: (v) => setState(() => storeValue = v!),
            textStyles: textStyles,
          ),

          const SizedBox(height: 32),

          // -------------------- ВЫБОР ТЕМЫ --------------------
          Text(
            'Выбор темы интерфейса',
            style: textStyles.settingsPageSectionTitle,
          ),
          const SizedBox(height: 12),

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

  final List<List<ThemeSetting>> themeSets = [
    [
      ThemeSetting(color: Colors.red, isLightTheme: true),
      ThemeSetting(color: Colors.orange, isLightTheme: true),
      ThemeSetting(color: Colors.yellow, isLightTheme: true),
      ThemeSetting(color: Colors.white, isLightTheme: true),
      ThemeSetting(color: Colors.green, isLightTheme: true),
      ThemeSetting(color: Colors.blue, isLightTheme: true),
      ThemeSetting(color: Colors.purple, isLightTheme: true),
    ],
    [
      ThemeSetting(color: Colors.red, isLightTheme: false),
      ThemeSetting(color: Colors.orange, isLightTheme: false),
      ThemeSetting(color: Colors.yellow, isLightTheme: false),
      ThemeSetting(color: Colors.black, isLightTheme: false),
      ThemeSetting(color: Colors.green, isLightTheme: false),
      ThemeSetting(color: Colors.blue, isLightTheme: false),
      ThemeSetting(color: Colors.purple, isLightTheme: false),
    ],
    // ещё 2 ряда можно добавить аналогично
    [
      ThemeSetting(color: Colors.pink, isLightTheme: true),
      ThemeSetting(color: Colors.teal, isLightTheme: true),
      ThemeSetting(color: Colors.cyan, isLightTheme: true),
      ThemeSetting(color: Colors.white, isLightTheme: true),
      ThemeSetting(color: Colors.lime, isLightTheme: true),
      ThemeSetting(color: Colors.brown, isLightTheme: true),
      ThemeSetting(color: Colors.indigo, isLightTheme: true),
    ],
    [
      ThemeSetting(color: Colors.pink, isLightTheme: false),
      ThemeSetting(color: Colors.teal, isLightTheme: false),
      ThemeSetting(color: Colors.cyan, isLightTheme: false),
      ThemeSetting(color: Colors.black, isLightTheme: false),
      ThemeSetting(color: Colors.lime, isLightTheme: false),
      ThemeSetting(color: Colors.brown, isLightTheme: false),
      ThemeSetting(color: Colors.indigo, isLightTheme: false),
    ],
  ];

  ThemeSetting? selectedSetting;

  List<Widget> _buildThemeRows(BuildContext context, AppTypography textStyles) {
    return themeSets.map((row) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              row.map((setting) {
                final isSelected = selectedSetting == setting;
                final innerColor =
                    setting.isLightTheme ? Colors.white : Colors.black;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedSetting = setting);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: setting.color,
                      border: Border.all(color: setting.color, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: innerColor,
                          shape: BoxShape.circle,
                          border:
                              isSelected
                                  ? Border.all(color: innerColor, width: 2)
                                  : null,
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

// dummy extensions to avoid errors in canvas
