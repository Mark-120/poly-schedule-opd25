import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/theme_extension.dart';
import '../../core/presentation/constants.dart';
import '../widgets/featured_card.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _editMode = false;
  final List<List<String>> _featuredData;

  final List<String> _pageTitles = [
    AppStrings.groupsFeaturedPageTitle,
    AppStrings.lecturersFeaturedPageTitle,
    AppStrings.classesFeaturedPageTitle,
  ];

  _FeaturedScreenState()
    : _featuredData = [
        List.generate(15, (e) => '5130903/3000$e'),
        List.generate(4, (e) => 'Филимоненкова Надежда Викторовна'),
        List.generate(
          8,
          (e) =>
              e == 0
                  ? '132 ауд. 11 уч. корпус'
                  : '156 ауд. Гидротехнический уч. корпус',
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  void _deleteItem(int pageIndex, int index) {
    setState(() {
      _featuredData[pageIndex].removeAt(index);
    });
  }

  void _reorderItems(int pageIndex, int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _featuredData[pageIndex].removeAt(oldIndex);
      _featuredData[pageIndex].insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics:
                  _editMode
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: List.generate(
                _pageTitles.length,
                (i) => _featuredSection(i, context),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                _editMode
                    ? Padding(
                      key: ValueKey('add_button'),
                      padding: const EdgeInsets.only(top: 57),
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.add,
                          color: context.appTheme.iconColor,
                          size: 38,
                        ),
                      ),
                    )
                    : Padding(
                      key: ValueKey('edit_button'),
                      padding: const EdgeInsets.only(top: 57),
                      child: FloatingActionButton(
                        onPressed: _toggleEditMode,
                        child: Icon(
                          Icons.edit_outlined,
                          color: context.appTheme.iconColor,
                        ),
                      ),
                    ),
          ),
          AnimatedOpacity(
            opacity: _editMode ? 0.0 : 1.0,
            duration: Duration(milliseconds: 500),
            child: Padding(
              key: ValueKey('page_routing_dots'),
              padding: EdgeInsets.symmetric(vertical: 56),
              child: _bottomIndicator(),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _editMode
              ? FloatingActionButton(
                onPressed: _toggleEditMode,
                child: Icon(
                  Icons.done,
                  color: context.appTheme.iconColor,
                  size: 40,
                ),
              )
              : null,
    );
  }

  Widget _featuredSection(int pageIndex, BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 36),
          child: Column(
            children: [
              Text(_pageTitles[pageIndex], style: textStyles.title),
              AnimatedOpacity(
                key: ValueKey('edit_title'),
                opacity: _editMode ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    AppStrings.editModeSubtitle,
                    style: textStyles.subtitleChangeMode,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  _editMode
                      ? ReorderableListView.builder(
                        key: ValueKey('reorder_list'),
                        physics: const ClampingScrollPhysics(),
                        itemCount: _featuredData[pageIndex].length,
                        onReorder:
                            (oldIndex, newIndex) =>
                                _reorderItems(pageIndex, oldIndex, newIndex),
                        itemBuilder:
                            (context, index) =>
                                _editableCard(pageIndex, index, context),
                      )
                      : ListView.builder(
                        key: ValueKey('choose_list'),
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _featuredData[pageIndex].length,
                        itemBuilder:
                            (_, index) => featuredCard(
                              _featuredData[pageIndex][index],
                              context,
                            ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editableCard(int pageIndex, int index, BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Row(
      key: Key('item_$index'),
      children: [
        Expanded(
          child: Card(
            color: context.appTheme.firstLayerCardBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _featuredData[pageIndex][index],
                      style: textStyles.itemText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Image.asset('assets/icons/drag_icon.png'),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: context.appTheme.secondaryColor),
          onPressed: () => _deleteItem(pageIndex, index),
        ),
      ],
    );
  }

  Widget _bottomIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 23),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? context.appTheme.primaryColor
                        : context.appTheme.secondLayerCardBackgroundColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}
