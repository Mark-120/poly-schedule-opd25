import 'package:flutter/material.dart';

import '../../domain/entities/room.dart';
import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/theme_extension.dart';
import '../../core/presentation/app_strings.dart';
import '../widgets/featured_card.dart';
import 'schedule_screen.dart';

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
    final textStyles = AppTextStylesProvider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(AppStrings.classSearchTitle, style: textStyles.title),
            const SizedBox(height: 65),
            Expanded(child: _buildSearchResults(context)),
            Padding(
              padding: EdgeInsets.only(top: 88, bottom: 112),
              child: Text(
                AppStrings.secondPage,
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
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (e) => ScheduleScreen.room(
                              roomId: RoomId(roomId: 669, buildingId: 25),
                              dayTime: DateTime.now(),
                              bottomTitle: 'Здание',
                            ),
                      ),
                    ),
                child: Icon(
                  Icons.done,
                  color: context.appTheme.iconColor,
                  size: 40,
                ),
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
          context,
          _allClasses[index],
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
