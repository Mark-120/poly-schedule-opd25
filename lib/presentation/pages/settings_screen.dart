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
        // DropdownButton<String>(
        //   items: List.generate(
        //     valueList.length,
        //     (i) => DropdownMenuItem(
        //       value: valueList[i],
        //       child: Text(valueList[i]),
        //     ),
        //   ),
        //   onChanged: onTap,
        // ),
        // Expanded(
        //   child: Card(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(15),
        //     ),
        //     elevation: 0,
        //     color: const Color(0xFFCFE3CF),
        //     child: InkWell(
        //       borderRadius: BorderRadius.circular(15),
        //       onTap: onTap,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(
        //           vertical: 9,
        //           horizontal: 16,
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               value,
        // style: TextStyle(
        //   fontSize: 16,
        //   fontWeight: FontWeight.w400,
        //   color: Color(0xFF244029),
        //               ),
        //               maxLines: 1,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             Icon(Icons.expand_more),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
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

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Выберите тему',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ..._themeOptions.map(
              (theme) => ListTile(
                title: Text(theme),
                trailing:
                    _selectedTheme == theme
                        ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                        : null,
                onTap: () {
                  setState(() => _selectedTheme = theme);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        );
      },
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Выберите язык',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ..._languageOptions.map(
              (lang) => ListTile(
                title: Text(lang),
                trailing:
                    _selectedLanguage == lang
                        ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                        : null,
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        );
      },
    );
  }

  void _reportBug() {
    // Реализация отправки сообщения об ошибке
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Сообщить об ошибке'),
            content: const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Опишите проблему...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  // Отправка сообщения
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Спасибо за ваш отзыв!')),
                  );
                },
                child: const Text('Отправить'),
              ),
            ],
          ),
    );
  }

  void _saveSettings() {
    // Сохранение настроек
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Настройки сохранены')));
    Navigator.pop(context);
  }
}
