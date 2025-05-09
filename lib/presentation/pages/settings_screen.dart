import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/presentation/app_text_styles.dart';
import 'package:poly_scheduler/core/presentation/theme_extension.dart';

import '../../core/presentation/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = AppThemeMode.system.displayName;

  final List<String> _themeOptions = ['Светлая', 'Темная', 'Системная'];

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
              valueList: _themeOptions,
              onTap: (String? newValue) {
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
    required String value,
    required List<String> valueList,
    required void Function(String?)? onTap,
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
    String value,
    List<String> valueList,
    void Function(String?)? onTap,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: context.appTheme.firstLayerCardBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
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
            valueList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    value,
                    style: AppTextStylesProvider.of(context).itemText,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

enum AppThemeMode  {
  light('Светлая'),
  dark('Темная'),
  system('Системная');

  final String displayName;

  const AppThemeMode (this.displayName);

  static AppThemeMode fromDisplayName(String displayName) {
    return values.firstWhere(
      (e) => e.displayName == displayName,
      orElse: () => AppThemeMode.system,
    );
  }
}
