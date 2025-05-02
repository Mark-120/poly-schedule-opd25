import 'package:flutter/material.dart';
import 'class_search_screen.dart';
import '../widgets/featured_card.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Поиск здания',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Color(0xFF244029),
              ),
            ),
            const SizedBox(height: 65),
            Expanded(child: _buildSearchResults()),
            Padding(
              padding: EdgeInsets.only(top: 88, bottom: 112),
              child: Text(
                '1/2',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Color(0xFF244029),
                ),
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
                backgroundColor: const Color(0xFF4FA24E),
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                  size: 40,
                ),
              )
              : null,
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _allBuildings.length,
      itemBuilder: (context, index) {
        return featuredCard(
          _allBuildings[index],
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
