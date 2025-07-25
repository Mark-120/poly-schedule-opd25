import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../presentation/widgets/featured_card.dart';
import '../../service_locator.dart';
import '../state_managers/search_screen_bloc/search_bloc.dart';
import 'schedule_screen.dart';

class SearchScreen extends StatefulWidget {
  final SearchScreenType searchScreenType;
  final Function(Group)? onSaveGroup;
  final Function(Teacher)? onSaveTeacher;

  const SearchScreen._({
    required this.searchScreenType,
    this.onSaveGroup,
    this.onSaveTeacher,
  });

  factory SearchScreen.groups({required Function(Group) onSaveGroup}) {
    return SearchScreen._(
      searchScreenType: SearchScreenType.groups,
      onSaveGroup: onSaveGroup,
    );
  }

  factory SearchScreen.teachers({required Function(Teacher) onSaveTeacher}) {
    return SearchScreen._(
      searchScreenType: SearchScreenType.teachers,
      onSaveTeacher: onSaveTeacher,
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    return BlocProvider(
      create:
          (context) => SearchBloc(
            findGroups: sl(),
            findTeachers: sl(),
            addFeaturedGroup: sl(),
            addFeaturedTeacher: sl(),
          ),
      child: Scaffold(
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
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchResultsLoaded && state.selectedItem != null) {
              return FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: () {
                  context.read<SearchBloc>().add(const SaveToFeatured());

                  if (state.searchType == SearchScreenType.groups) {
                    final group = state.selectedItem as Group;
                    widget.onSaveGroup!(group);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (e) => ScheduleScreen.group(
                              groupId: group.id,
                              dayTime: DateTime.now(),
                              bottomTitle: group.name,
                            ),
                      ),
                    );
                  } else {
                    final teacher = state.selectedItem as Teacher;
                    widget.onSaveTeacher!(teacher);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (e) => ScheduleScreen.teacher(
                              teacherId: teacher.id,
                              dayTime: DateTime.now(),
                              bottomTitle: AppStrings.fullNameToAbbreviation(
                                teacher.fullName,
                              ),
                            ),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.done,
                  color: context.appTheme.iconColor,
                  size: 40,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
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
        child: BlocBuilder<SearchBloc, SearchState>(
          builder:
              (context, state) => TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: _searchController,
                onChanged: (query) {
                  context.read<SearchBloc>().add(
                    SearchQueryChanged(query, widget.searchScreenType),
                  );
                },
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
                    onPressed:
                        () => () {
                          context.read<SearchBloc>().add(
                            SearchQueryChanged(
                              _searchController.text,
                              widget.searchScreenType,
                            ),
                          );
                        },
                  ),
                ),
                style: textStyles.searchField.copyWith(
                  color: context.appTheme.secondaryColor,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return _buildInitialView(context);
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        } else if (state is SearchResultsLoaded) {
          return _buildResultsList(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInitialView(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);
    return Center(
      child: Text(
        AppStrings.searchCenterHint,
        style: textStyles.noInfoMessage,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, SearchState state) {
    if (state is! SearchResultsLoaded) return const SizedBox.shrink();

    final textStyles = AppTextStylesProvider.of(context);
    final results = state.results;

    if (results.isEmpty) {
      return Center(
        child: Text(
          AppStrings.emptyResultCenterHint(_searchController.text),
          style: textStyles.noInfoMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isSelected = item == state.selectedItem;
        final displayText =
            widget.searchScreenType == SearchScreenType.groups
                ? (item as Group).name
                : (item as Teacher).fullName;

        return featuredCard(
          context,
          displayText,
          isChosen: isSelected,
          onTap: () {
            context.read<SearchBloc>().add(
              SearchItemSelected(item, widget.searchScreenType),
            );
          },
        );
      },
    );
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
