import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/configs/assets/app_vectors.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => NavigationWrapperState();
}

class NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    Center(child: Text('Schedule')),
    Center(child: Text('Search')),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        notchMargin: 0,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(AppVectors.schedule, 0),
            _buildNavItem(AppVectors.search, 1),
            _buildNavItem(AppVectors.settings, 2),
          ],
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
          _currentIndex == index
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
