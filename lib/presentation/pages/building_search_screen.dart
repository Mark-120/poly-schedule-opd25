import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/constants.dart';
import '../../core/presentation/theme_extension.dart';
import '../widgets/featured_card.dart';
import 'class_search_screen.dart';

class BuildingSearchScreen extends StatefulWidget {
  const BuildingSearchScreen({super.key});

  @override
  State<BuildingSearchScreen> createState() => _BuildingSearchScreenState();
}

class _BuildingSearchScreenState extends State<BuildingSearchScreen> {
  late final List<String> _allBuildings;
  int _chosenIndex = 0;
  bool _isChosen = false;

  @override
  void initState() {
    super.initState();
    _allBuildings = [
      'Завод «Силовые Машины»',
      '2-й учебный корпус',
      'Институт высокомолекулярных соединений',
      'Научно-исследовательский корпус',
      'Институт ядерной энергетики (филиал ФГАОУ ВО СПбПУ) г. Сосновый Бор',
      'Корпус "Башня"',
      'Спорткомплекс',
      'Завод «Силовые Машины»',
      '2-й учебный корпус',
      'Институт высокомолекулярных соединений',
      'Научно-исследовательский корпус',
      'Институт ядерной энергетики (филиал ФГАОУ ВО СПбПУ) г. Сосновый Бор',
      'Корпус "Башня"',
      'Спорткомплекс',
      'Завод «Силовые Машины»',
      '2-й учебный корпус',
      'Институт высокомолекулярных соединений',
      'Научно-исследовательский корпус',
      'Институт ядерной энергетики (филиал ФГАОУ ВО СПбПУ) г. Сосновый Бор',
      'Корпус "Башня"',
      'Спорткомплекс',
      'Завод «Силовые Машины»',
      '2-й учебный корпус',
      'Институт высокомолекулярных соединений',
      'Научно-исследовательский корпус',
      'Институт ядерной энергетики (филиал ФГАОУ ВО СПбПУ) г. Сосновый Бор',
      'Корпус "Башня"',
      'Спорткомплекс',
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(AppStrings.buildingSearchTitle, style: textStyles.title),
            const SizedBox(height: 65),
            Expanded(child: _buildSearchResults(context)),
            Padding(
              padding: EdgeInsets.only(top: 88, bottom: 112),
              child: Text(
                AppStrings.firstPage,
                style: textStyles.noInfoMessage,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _isChosen
              ? FloatingActionButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassSearchScreen(),
                      ),
                    ),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: context.appTheme.iconColor,
                  size: 40,
                ),
              )
              : null,
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _allBuildings.length,
      itemBuilder: (context, index) {
        return featuredCard(
          _allBuildings[index],
          context,
          isChosen: index == _chosenIndex && _isChosen,
          onTap: () {
            setState(() {
              _chosenIndex = index;
              _isChosen = true;
            });
          },
        );
      },
    );
  }
}
