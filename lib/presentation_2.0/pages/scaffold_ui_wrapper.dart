import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/navigation/page_wrapper.dart';
import '../../core/presentation/navigation/scaffold_ui_state/global_navigation_ontroller.dart';
import '../../domain/entities/featured.dart';
import 'featured_page.dart';
import 'schedule_page.dart';

class ScaffoldUiWrapper extends StatefulWidget {
  final Featured? lastFeatured;
  const ScaffoldUiWrapper({super.key, this.lastFeatured});

  @override
  State<ScaffoldUiWrapper> createState() => ScaffoldUiWrapperState();
}

class ScaffoldUiWrapperState extends State<ScaffoldUiWrapper> {
  final navController = GlobalNavigationController();

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<PageWrapper> screens;

  @override
  void initState() {
    super.initState();

    navigatorKeys = List.generate(3, (index) => GlobalKey<NavigatorState>());
    navController.addListener(_onNavControllerChanged);
    // Регистрируем ключи в контроллер
    for (var i = 0; i < navigatorKeys.length; i++) {
      navController.registerNavigatorKey(i, navigatorKeys[i]);
    }

    final lastFeatured = widget.lastFeatured;

    screens = [
      PageWrapper(
        navigatorKey: navigatorKeys[0],
        child: SchedulePage(featured: lastFeatured, dayTime: DateTime.now()),
      ),
      PageWrapper(navigatorKey: navigatorKeys[1], child: FeaturedPage()),
      PageWrapper(
        navigatorKey: navigatorKeys[2],
        child: Center(child: Text('Settings')),
      ),
    ];
  }

  void _onNavControllerChanged() {
    setState(() {}); // заставляем перестроить Scaffold
  }

  @override
  void dispose() {
    navController.removeListener(_onNavControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiConfig = screens[navController.currentIndex].controller;

    return ChangeNotifierProvider.value(
      value: navController,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          final NavigatorState currentNavigator =
              navigatorKeys[navController.currentIndex].currentState!;

          if (currentNavigator.canPop()) {
            currentNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(
              double.infinity,
              Theme.of(context).appBarTheme.toolbarHeight ?? 60,
            ),
            child: ListenableBuilder(
              listenable: uiConfig,
              builder: (context, _) => uiConfig.state.appBar ?? SizedBox(),
            ),
          ),
          floatingActionButton: ListenableBuilder(
            listenable: uiConfig,
            builder:
                (_, __) => uiConfig.state.floatingActionButton ?? SizedBox(),
          ),
          body: Consumer<GlobalNavigationController>(
            builder: (context, controller, _) {
              return IndexedStack(
                index: navController.currentIndex,
                children: screens,
              );
            },
          ),
          bottomNavigationBar: _buildBottomNav(),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Consumer<GlobalNavigationController>(
      builder: (_, controller, __) {
        return BottomAppBar(
          height: 60,
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(AppVectors.schedule, 0),
              _buildNavItem(AppVectors.search, 1),
              _buildNavItem(AppVectors.settings, 2),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(String svg, int index) {
    return Consumer<GlobalNavigationController>(
      builder: (_, controller, __) {
        return IconButton(
          iconSize: 32,
          icon: SvgPicture.asset(
            svg,
            colorFilter: ColorFilter.mode(
              controller.currentIndex == index
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.6),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            controller.goToTab(index);
          },
        );
      },
    );
  }
}
