import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/navigation/page_wrapper.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit_2.0/app_shadows.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/teacher.dart';
import 'featured_page.dart';
import 'schedule_page.dart';

class ScaffoldUiWrapper extends StatefulWidget {
  const ScaffoldUiWrapper({super.key});

  @override
  State<ScaffoldUiWrapper> createState() => ScaffoldUiWrapperState();
}

class ScaffoldUiWrapperState extends State<ScaffoldUiWrapper> {
  int currentIndex = 0;
  late final List<PageWrapper> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      PageWrapper(
        child: SchedulePage(
          id: EntityId.teacher(TeacherId(13445)),
          dayTime: DateTime.now(),
          bottomTitle: 'Щукин А.В.',
        ),
      ),
      PageWrapper(child: FeaturedPage()),
      PageWrapper(child: Center(child: Text('Settings'))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ScaffoldUiStateController uiConfig = screens[currentIndex].controller;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          Theme.of(context).appBarTheme.toolbarHeight ?? 60,
        ),
        child: ListenableBuilder(
          listenable: uiConfig,
          builder: (context, child) => uiConfig.state.appBar ?? SizedBox(),
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: uiConfig,
        builder:
            (context, child) =>
                uiConfig.state.floatingActionButton ?? SizedBox(),
      ),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [AppShadows.footerShadow],
        ),
        height: 60,
        child: BottomAppBar(
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppVectors.schedule, 0),
              _buildNavItem(AppVectors.search, 1),
              _buildNavItem(AppVectors.settings, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String svgTitle, int index) {
    return IconButton(
      iconSize: 32,
      icon: SvgPicture.asset(
        svgTitle,
        colorFilter: ColorFilter.mode(
          currentIndex == index
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}
