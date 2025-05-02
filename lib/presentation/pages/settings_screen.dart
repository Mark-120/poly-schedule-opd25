import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = 'Темная';
  String _selectedLanguage = 'Русский';

  final List<String> _themeOptions = ['Светлая', 'Темная', 'Системная'];
  final List<String> _languageOptions = ['Русский', 'English'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Настройки',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Color(0xFF244029),
              ),
            ),
            const SizedBox(height: 65),
            _buildSettingItem(
              title: 'Тема',
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
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Язык',
              value: _selectedLanguage,
              valueList: _languageOptions,
              onTap: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
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
                    child: const Text(
                      'Сообщить об ошибке',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF4CAF50),
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
        backgroundColor: const Color(0xFF4FA24E),
        shape: const CircleBorder(),
        elevation: 0,
        child: const Icon(Icons.done, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String value,
    required List<String> valueList,
    required void Function(String?)? onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Color(0xFF244029)),
        ),
        SizedBox(width: 16),
        Expanded(child: _buildThemeDropdown(value, valueList, onTap)),
      ],
    );
  }

  Widget _buildThemeDropdown(
    String value,
    List<String> valueList,
    void Function(String?)? onTap,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFCFE3CF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        alignment: AlignmentDirectional.topCenter,
        value: value,
        isExpanded: true,
        underline: Container(),
        items:
            valueList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF244029),
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
        onChanged: onTap,
        icon: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.expand_more, color: Color(0xFF244029)),
        ),
        dropdownColor: const Color(0xFFCFE3CF),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
