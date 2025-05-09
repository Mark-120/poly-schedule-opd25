import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/app_strings.dart';
import '../../core/presentation/theme_extension.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppThemeMode _selectedTheme = AppThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(AppStrings.settingsTitle, style: textStyles.title),
            const SizedBox(height: 65),
            _buildSettingItem(
              context,
              title: AppStrings.themeOption,
              value: _selectedTheme,
              valueList: AppThemeMode.values,
              onTap: (AppThemeMode? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                  });
                }
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      AppStrings.errorReportButton,
                      style: textStyles.itemText.copyWith(
                        color: context.appTheme.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: context.appTheme.primaryColor,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 130),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.done, color: context.appTheme.iconColor, size: 40),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required AppThemeMode value,
    required List<AppThemeMode> valueList,
    required void Function(AppThemeMode?)? onTap,
  }) {
    return Row(
      children: [
        Text(title, style: AppTextStylesProvider.of(context).itemText),
        SizedBox(width: 16),
        Expanded(child: _buildThemeDropdown(context, value, valueList, onTap)),
      ],
    );
  }

  Widget _buildThemeDropdown(
    BuildContext context,
    AppThemeMode value,
    List<AppThemeMode> valueList,
    void Function(AppThemeMode?)? onTap,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: context.appTheme.firstLayerCardBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<AppThemeMode>(
        alignment: AlignmentDirectional.topCenter,
        value: value,
        isExpanded: true,
        underline: Container(),
        icon: Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.expand_more,
            color: context.appTheme.secondaryColor,
          ),
        ),
        dropdownColor: context.appTheme.firstLayerCardBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        onChanged: onTap,
        items:
            valueList.map((AppThemeMode value) {
              return DropdownMenuItem<AppThemeMode>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    value.displayName,
                    style: AppTextStylesProvider.of(context).itemText,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

enum AppThemeMode {
  light('Светлая'),
  dark('Темная'),
  system('Системная');

  final String displayName;

  const AppThemeMode(this.displayName);

  static AppThemeMode fromDisplayName(String displayName) {
    return values.firstWhere(
      (e) => e.displayName == displayName,
      orElse: () => AppThemeMode.system,
    );
  }
}
