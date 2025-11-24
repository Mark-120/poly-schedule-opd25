import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../core/services/error_handling_service.dart';
import '../../core/services/last_featured_service.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../presentation/pages/schedule_screen.dart';
import '../../service_locator.dart';
import '../state_managers/featured_screen_bloc/featured_bloc.dart';
import '../widgets/featured_card.dart';
import 'building_search_screen.dart';
import 'search_screen.dart';

class FeaturedScreen extends StatelessWidget {
  static const route = '/featured';

  const FeaturedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FeaturedBloc>()..add(LoadFeaturedData()),
      child: BlocBuilder<FeaturedBloc, FeaturedState>(
        builder: (context, state) {
          return _FeaturedScreenBody();
        },
      ),
    );
  }
}

class _FeaturedScreenBody extends StatefulWidget {
  @override
  State<_FeaturedScreenBody> createState() => _FeaturedScreenBodyState();
}

class _FeaturedScreenBodyState extends State<_FeaturedScreenBody> {
  final PageController _pageController = PageController();
  FeaturedSubpages _currentPage = FeaturedSubpages.values.first;
  bool _editMode = false;

  final List<String> _pageTitles =
      FeaturedSubpages.values.map((e) => e.title).toList();

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedBloc, FeaturedState>(
      builder: (context, state) {
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
                      _currentPage = FeaturedSubpages.values[index];
                    });
                  },
                  children: [
                    _featuredSection(
                      context,
                      pageIndex: 0,
                      items:
                          state is FeaturedLoaded
                              ? state.groups.map((g) => g.name).toList()
                              : [],
                      onReorder: (oldIndex, newIndex) {
                        context.read<FeaturedBloc>().add(
                          ReorderGroups(oldIndex, newIndex),
                        );
                      },
                      onDelete: (index) {
                        context.read<FeaturedBloc>().add(DeleteGroup(index));
                      },
                    ),
                    _featuredSection(
                      context,
                      pageIndex: 1,
                      items:
                          state is FeaturedLoaded
                              ? state.teachers.map((t) => t.fullName).toList()
                              : [],
                      onReorder: (oldIndex, newIndex) {
                        context.read<FeaturedBloc>().add(
                          ReorderTeachers(oldIndex, newIndex),
                        );
                      },
                      onDelete: (index) {
                        context.read<FeaturedBloc>().add(DeleteTeacher(index));
                      },
                    ),
                    _featuredSection(
                      context,
                      pageIndex: 2,
                      items:
                          state is FeaturedLoaded
                              ? state.rooms
                                  .map((r) => AppStrings.shortNameOfRoom(r))
                                  .toList()
                              : [],
                      onReorder: (oldIndex, newIndex) {
                        context.read<FeaturedBloc>().add(
                          ReorderRooms(oldIndex, newIndex),
                        );
                      },
                      onDelete: (index) {
                        context.read<FeaturedBloc>().add(DeleteRoom(index));
                      },
                    ),
                  ],
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
                            heroTag: UniqueKey(),
                            onPressed: _openSearchScreen,
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
                            heroTag: UniqueKey(),
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
      },
    );
  }

  Widget _featuredSection(
    BuildContext context, {
    required int pageIndex,
    required List<String> items,
    required Function(int, int) onReorder,
    required Function(int) onDelete,
  }) {
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
              child: BlocBuilder<FeaturedBloc, FeaturedState>(
                builder: (context, state) {
                  if (state is FeaturedLoaded) {
                    return items.isEmpty
                        ? Center(
                          child: Text(
                            AppStrings.emptyFeaturedHint,
                            style: textStyles.noInfoMessage,
                          ),
                        )
                        : _editMode
                        ? ReorderableListView.builder(
                          buildDefaultDragHandles: false,
                          key: ValueKey('reorder_list'),
                          physics: const ClampingScrollPhysics(),
                          itemCount: items.length,
                          onReorder:
                              (oldIndex, newIndex) =>
                                  onReorder(oldIndex, newIndex),
                          itemBuilder:
                              (context, index) => _editableCard(
                                context,
                                index,
                                items[index],
                                () => onDelete(index),
                              ),
                          proxyDecorator:
                              (child, index, animation) =>
                                  Material(elevation: 0, child: child),
                        )
                        : ListView.builder(
                          key: ValueKey('choose_list'),
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder:
                              (_, index) => FeaturedCard(
                                items[index],
                                onTap: () => _openSelectedSchedule(index),
                              ),
                        );
                  } else if (state is FeaturedError) {
                    ErrorHandlingService.handleError(context, state.message);
                    return Center(
                      child: Text(
                        AppStrings.errorMessage,
                        style: textStyles.noLessonsMessage,
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editableCard(
    BuildContext context,
    int index,
    String title,
    VoidCallback onDelete,
  ) {
    final textStyles = AppTextStylesProvider.of(context);

    return Row(
      key: Key(title),
      children: [
        Expanded(
          child: ReorderableDragStartListener(
            index: index,
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              color: context.appTheme.firstLayerCardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
        ),
        IconButton(
          icon: Icon(Icons.close, color: context.appTheme.secondaryColor),
          onPressed: onDelete,
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
                    _currentPage.index == index
                        ? context.appTheme.primaryColor
                        : context.appTheme.secondLayerCardBackgroundColor,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _openSearchScreen() {
    switch (_currentPage) {
      case FeaturedSubpages.groups:
        Navigator.of(context).pushNamed(
          SearchScreen.route,
          arguments: SearchScreenArguments.groups(onSaveGroup: onSaveGroup),
        );
        break;
      case FeaturedSubpages.teachers:
        Navigator.of(context).pushNamed(
          SearchScreen.route,
          arguments: SearchScreenArguments.teachers(
            onSaveTeacher: onSaveTeacher,
          ),
        );
        break;
      case FeaturedSubpages.classes:
        Navigator.of(context).pushNamed(
          BuildingSearchScreen.route,
          arguments: BuildingSearchScreenArguments(onSaveRoom: onSaveRoom),
        );
        break;
    }
  }

  void _openSelectedSchedule(int index) {
    final bloc = context.read<FeaturedBloc>();
    final state = bloc.state;

    if (state is! FeaturedLoaded) return;

    switch (_currentPage) {
      case FeaturedSubpages.groups:
        if (index < state.groups.length) {
          final group = state.groups[index];
          onSaveGroup(group);
          Navigator.of(context).pushNamedAndRemoveUntil(
            ScheduleScreen.route,
            (route) => false,
            arguments: ScheduleScreenArguments(
              id: EntityId.group(group.id),
              dayTime: DateTime.now(),
              bottomTitle: group.name,
            ),
          );
        }
        break;
      case FeaturedSubpages.teachers:
        if (index < state.teachers.length) {
          final teacher = state.teachers[index];
          onSaveTeacher(teacher);
          Navigator.of(context).pushNamedAndRemoveUntil(
            ScheduleScreen.route,
            (route) => false,
            arguments: ScheduleScreenArguments(
              id: EntityId.teacher(teacher.id),
              dayTime: DateTime.now(),
              bottomTitle: AppStrings.fullNameToAbbreviation(teacher.fullName),
            ),
          );
        }
        break;
      case FeaturedSubpages.classes:
        if (index < state.rooms.length) {
          final room = state.rooms[index];
          onSaveRoom(room);
          Navigator.of(context).pushNamedAndRemoveUntil(
            ScheduleScreen.route,
            (route) => false,
            arguments: ScheduleScreenArguments(
              id: EntityId.room(room.getId()),
              dayTime: DateTime.now(),
              bottomTitle: AppStrings.shortNameOfRoom(room),
            ),
          );
        }
        break;
    }
  }

  void onSaveRoom(Room room) {
    context.read<LastFeaturedService>().save(
      featured: Featured(room, isFeatured: true),
    );
  }

  void onSaveGroup(Group group) {
    context.read<LastFeaturedService>().save(
      featured: Featured(group, isFeatured: true),
    );
  }

  void onSaveTeacher(Teacher teacher) {
    context.read<LastFeaturedService>().save(
      featured: Featured(teacher, isFeatured: true),
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
