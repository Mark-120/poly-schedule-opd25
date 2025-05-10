import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/theme_extension.dart';
import '../../core/presentation/app_strings.dart';
import '../../presentation/widgets/featured_card.dart';
import 'schedule_screen.dart';

class SearchScreen extends StatefulWidget {
  final SearchScreenType searchScreenType;
  const SearchScreen({super.key, required this.searchScreenType});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  late final List<String> _allFeatured;
  int _chosenIndex = 0;
  bool _isChosen = false;

  @override
  void initState() {
    super.initState();
    _allFeatured = _getFeaturedListByType(widget.searchScreenType);
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults =
          _allFeatured
              .where(
                (featured) =>
                    featured.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      _isChosen = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              _getStringByType(
                widget.searchScreenType,
                groupString: AppStrings.groupSearchTitle,
                teacherString: AppStrings.teacherSearchTitle,
              ),
              style: textStyles.title,
            ),
            const SizedBox(height: 65),
            _buildSearchField(context),
            const SizedBox(height: 20),
            Expanded(child: _buildSearchResults(context)),
          ],
        ),
      ),
      floatingActionButton:
          _isChosen
              ? FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed:
                    () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (e) => ScheduleScreen())),
                child: Icon(
                  Icons.done,
                  color: context.appTheme.iconColor,
                  size: 40,
                ),
              )
              : null,
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.searchFieldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.appTheme.secondaryColor, width: 2),
      ),
      child: SizedBox(
        height: 40,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _searchController,
          onChanged: _performSearch,
          cursorColor: context.appTheme.secondaryColor,
          selectionControls: materialTextSelectionHandleControls,
          decoration: InputDecoration(
            hintText: _getStringByType(
              widget.searchScreenType,
              groupString: AppStrings.searchGroupHint,
              teacherString: AppStrings.searchTeacherHint,
            ),
            hintStyle: textStyles.searchField,
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            prefixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: context.appTheme.secondaryColor,
                size: 24,
              ),
              onPressed: () => _performSearch(_searchController.text),
            ),
          ),
          style: textStyles.searchField.copyWith(
            color: context.appTheme.secondaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    if (_searchController.text.isEmpty) {
      return Center(
        child: Text(
          AppStrings.searchCenterHint,
          style: textStyles.noInfoMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          AppStrings.emptyResultCenterHint(_searchController.text),
          style: textStyles.noInfoMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return featuredCard(
          context,
          _searchResults[index],
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

  List<String> _getFeaturedListByType(SearchScreenType searchScreenType) {
    switch (searchScreenType) {
      case SearchScreenType.groups:
        return [
          '5130903/30001',
          '5130903/30002',
          '5130903/30003',
          '5130904/30001',
          '5130904/30002',
          '5130905/30001',
        ];
      case SearchScreenType.teachers:
        return [
          'Филимоненкова Надежда Викторовна',
          'Щукин Александр Валентинович',
          'Пак Вадим Геннадьевич',
          'Андрианова Екатерина Евгеньевна',
          'Хитров Егор Германович',
          'Бышук Галина Владимировна',
        ];
    }
  }

  String _getStringByType(
    SearchScreenType searchScreenType, {
    required String groupString,
    required String teacherString,
  }) {
    switch (searchScreenType) {
      case SearchScreenType.groups:
        return groupString;
      case SearchScreenType.teachers:
        return teacherString;
    }
  }
}

enum SearchScreenType { groups, teachers }
