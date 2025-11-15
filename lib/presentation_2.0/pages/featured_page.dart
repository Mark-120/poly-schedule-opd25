import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';
import '../../presentation/state_managers/featured_screen_bloc/featured_bloc.dart';
import '../../service_locator.dart';

class FeaturedPage extends StatelessWidget {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    _buildAppBar(context);
    return BlocProvider(
      create: (context) => sl<FeaturedBloc>()..add(LoadFeaturedData()),
      child: BlocBuilder<FeaturedBloc, FeaturedState>(
        builder: (context, state) {
          return _FeaturedPageBody();
        },
      ),
    );
  }

  void _buildAppBar(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScaffoldUiStateController>().update(
        ScaffoldUiState(
          appBar: AppBar(
            title: Text('Поиск расписания', style: textStyles.appBarTitle),
          ),
        ),
      );
    });
  }
}

class _FeaturedPageBody extends StatefulWidget {
  const _FeaturedPageBody();

  @override
  State<_FeaturedPageBody> createState() => _FeaturedPageBodyState();
}

class _FeaturedPageBodyState extends State<_FeaturedPageBody> {
  int _currentPageIndex = 0;
  final _featuredSectionKey = GlobalKey<_FeaturedSectionState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        children: [
          _NavigationBar(
            currentIndex: _currentPageIndex,
            onTap: (index) async {
              await _featuredSectionKey.currentState?.jumpTo(index);
            },
          ),
          SizedBox(height: 24),
          _FeaturedSection(
            key: _featuredSectionKey,
            onPageChanged: changeIndex,
          ),
        ],
      ),
    );
  }

  void changeIndex(int i) {
    setState(() => _currentPageIndex = i);
  }
}

class _NavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavigationBar({required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<ThemeColors>()!.tile,
        borderRadius: BorderRadius.circular(50),
      ),
      height: 37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(context, 0),
          _buildNavigationButton(context, 1),
          _buildNavigationButton(context, 2),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, int index) {
    final isChosen = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:
                isChosen ? Theme.of(context).primaryColor : Colors.transparent,
          ),
          // padding: ,
          height: 37,
          child: Center(
            child: Text(
              FeaturedSubpages.values[index].title,
              textAlign: TextAlign.center,
              style:
                  isChosen
                      ? Theme.of(
                        context,
                      ).extension<AppTypography>()!.navigationBarItemChosen
                      : Theme.of(
                        context,
                      ).extension<AppTypography>()!.navigationBarItem,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatefulWidget {
  final ValueChanged<int> onPageChanged;
  const _FeaturedSection({super.key, required this.onPageChanged});

  @override
  State<_FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<_FeaturedSection> {
  final PageController _pageController = PageController();
  bool _editMode = false;
  int _currentPageIndex = 0;

  Future<void> jumpTo(int index) async {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedBloc, FeaturedState>(
      builder: (context, state) {
        return Expanded(
          child: PageView(
            physics:
                _editMode
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
            controller: _pageController,
            onPageChanged: widget.onPageChanged,
            children: [Placeholder(), Placeholder(), Placeholder()],
          ),
        );
      },
    );
  }
}

enum FeaturedSubpages {
  groups(AppStrings.groupsFeaturedPageTitle),
  teachers(AppStrings.lecturersFeaturedPageTitle),
  classes(AppStrings.classesFeaturedPageTitle);

  final String title;

  const FeaturedSubpages(this.title);
}
