import 'package:flutter/material.dart';

import '../widgets/featured_card.dart';

class ClassSearchScreen extends StatefulWidget {
  const ClassSearchScreen({super.key});

  @override
  State<ClassSearchScreen> createState() => _ClassSearchScreenState();
}

class _ClassSearchScreenState extends State<ClassSearchScreen> {
  late final List<String> _allClasses;
  int _chosenIndex = 0;
  bool _isChosen = false;

  @override
  void initState() {
    super.initState();
    _allClasses =
        List.generate(40, (i) => '1$i') +
        [
          'Белый зал',
          'Практическая',
          'Спорт. зал',
          '1202 ГПН, лекционная',
          'ЛБиБ ВШБСиТ',
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
              'Поиск аудитории',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Color(0xFF244029),
              ),
            ),
            const SizedBox(height: 65),
            Expanded(child: _buildSearchResults(context)),
            Padding(
              padding: EdgeInsets.only(top: 88, bottom: 112),
              child: Text(
                '2/2',
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
                onPressed: () {},
                backgroundColor: const Color(0xFF4FA24E),
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(Icons.done, color: Colors.white, size: 40),
              )
              : null,
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 3,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(_allClasses.length, (index) {
        return featuredCard(
          _allClasses[index], context,
          isChosen: index == _chosenIndex && _isChosen,
          isCenterText: true,
          onTap: () {
            setState(() {
              _chosenIndex = index;
              _isChosen = true;
            });
          },
        );
      }),
    );
  }
}
