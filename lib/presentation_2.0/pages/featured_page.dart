import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/configs/assets/app_vectors.dart';
import '../../core/presentation/navigation/scaffold_ui_state/global_navigation_ontroller.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/presentation/uikit_2.0/theme_colors.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/entity.dart';
import '../../domain/entities/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../presentation/state_managers/featured_screen_bloc/featured_bloc.dart';
import '../../service_locator.dart';
import '../state_managers/search_screen_bloc/search_bloc.dart';
import '../widgets/editable_featured_dard.dart';
import '../widgets/featured_card.dart';
import 'schedule_page.dart';

class FeaturedPage extends StatelessWidget {
  const FeaturedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FeaturedBloc>()..add(LoadFeaturedData()),
      child: BlocBuilder<FeaturedBloc, FeaturedState>(
        builder: (context, state) {
          return _FeaturedPageBody();
        },
      ),
    );
  }
}

class _FeaturedPageBody extends StatefulWidget {
  const _FeaturedPageBody();

  @override
  State<_FeaturedPageBody> createState() => _FeaturedPageBodyState();
}

class _FeaturedPageBodyState extends State<_FeaturedPageBody> {
  int _currentPageIndex = 0;
  bool _appBarInitialized = false;
  final _featuredSectionKey = GlobalKey<_FeaturedPageViewState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_appBarInitialized) {
      _setupAppBar();
      _appBarInitialized = true;
    }

    final nav = context.watch<GlobalNavigationController>();

    if (nav.currentIndex == 1) {
      context.read<FeaturedBloc>().add(LoadFeaturedData());
    }
  }

  void _setupAppBar() {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          _NavigationBar(
            currentIndex: _currentPageIndex,
            onTap: (index) async {
              await _featuredSectionKey.currentState?.jumpTo(index);
            },
          ),
          SizedBox(height: 24),
          _FeaturedPageView(
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
    final editMode =
        context
            .findAncestorStateOfType<_FeaturedPageViewState>()
            ?.editMode
            .value ??
        false;
    return Opacity(
      opacity: editMode ? 0.6 : 1.0,
      child: IgnorePointer(
        ignoring: editMode,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
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
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, int index) {
    final isChosen = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => onTap(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:
                isChosen ? Theme.of(context).primaryColor : Colors.transparent,
          ),
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

class _FeaturedPageView extends StatefulWidget {
  final ValueChanged<int> onPageChanged;
  const _FeaturedPageView({super.key, required this.onPageChanged});

  @override
  State<_FeaturedPageView> createState() => _FeaturedPageViewState();
}

class _FeaturedPageViewState extends State<_FeaturedPageView> {
  final PageController _pageController = PageController();
  ValueNotifier<bool> editMode = ValueNotifier(false);

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
        final List<String> groupFeatured =
            state is FeaturedLoaded
                ? state.groups.map((g) => g.name).toList()
                : [];
        final List<String> teacherFeatured =
            state is FeaturedLoaded
                ? state.teachers.map((g) => g.fullName).toList()
                : [];
        final List<String> classFeatured =
            state is FeaturedLoaded
                ? state.rooms.map((g) => g.name).toList()
                : [];
        final allFeatured = [groupFeatured, teacherFeatured, classFeatured];
        return Expanded(
          child: PageView(
            physics:
                editMode.value
                    ? NeverScrollableScrollPhysics()
                    : PageScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int index) {
              widget.onPageChanged(index);

              final items = allFeatured[index];
              final hasFavorites = items.isNotEmpty;

              if (!editMode.value && hasFavorites) {
                _showEditModeFab();
              } else if (!hasFavorites) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ScaffoldUiStateController>().clearFAB();
                });
              }
            },
            children: [
              _FeaturedSection(
                key: PageStorageKey('page1'),
                FeaturedSubpages.groups,
                items: groupFeatured,
              ),
              _FeaturedSection(
                key: PageStorageKey('page2'),
                FeaturedSubpages.teachers,
                items: teacherFeatured,
              ),
              _FeaturedSection(
                key: PageStorageKey('page3'),
                FeaturedSubpages.classes,
                items: classFeatured,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditModeFab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScaffoldUiStateController>().add(
        ScaffoldUiState(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _lockNavigation();
              _showEditDoneFab();
            },
            child: Icon(Icons.edit),
          ),
        ),
      );
    });
  }

  void _lockNavigation() {
    setState(() => editMode.value = true);
  }

  void _unlockNavigation() {
    setState(() => editMode.value = false);
  }

  void _showEditDoneFab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScaffoldUiStateController>().add(
        ScaffoldUiState(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _unlockNavigation();
              _showEditModeFab();
            },
            child: Icon(Icons.check),
          ),
        ),
      );
    });
  }
}

class _FeaturedSection extends StatelessWidget {
  final FeaturedSubpages sectionType;
  final List<String> items;
  const _FeaturedSection(this.sectionType, {required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final editMode =
        context
            .findAncestorStateOfType<_FeaturedPageViewState>()
            ?.editMode
            .value ??
        false;
    return BlocProvider(
      create: (context) => sl<NewSearchBloc>(),
      child: _FeaturedSectionBody(
        sectionType,
        items: items,
        editMode: editMode,
      ),
    );
  }
}

class _FeaturedSectionBody extends StatefulWidget {
  final FeaturedSubpages sectionType;
  final List<String> items;
  final bool editMode;
  const _FeaturedSectionBody(
    this.sectionType, {
    required this.items,
    required this.editMode,
  });

  @override
  State<_FeaturedSectionBody> createState() => _FeaturedSectionBodyState();
}

class _FeaturedSectionBodyState extends State<_FeaturedSectionBody> {
  final _searchController = TextEditingController();
  Featured<Building>? _selectedBuilding;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(context),
          SizedBox(height: 24),
          _buildFeaturedCards(context),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    if (widget.sectionType == FeaturedSubpages.classes &&
        _selectedBuilding != null) {
      return _buildSelectedBuildingHeader(context);
    }

    return Opacity(
      opacity: widget.editMode ? 0.6 : 1,
      child: IgnorePointer(
        ignoring: widget.editMode,
        child: _buildSearchInput(context),
      ),
    );
  }

  Widget _buildSelectedBuildingHeader(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    final primary = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<ThemeColors>()!.tile,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedBuilding!.entity.name,
              style: textStyles.searchFieldHint,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selectedBuilding = null;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                sl<NewSearchBloc>().add(
                  SearchQueryChanged('', widget.sectionType),
                );
                context.read<ScaffoldUiStateController>().clearFAB();
              });
            },
            child: Icon(Icons.close, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    final primaryColor = Theme.of(context).primaryColor;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).extension<ThemeColors>()!.tile,
          borderRadius: BorderRadius.circular(50),
        ),
        child: SizedBox(
          height: 40,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _searchController,
            onChanged: (query) {
              if (query.isNotEmpty) {
                context.read<NewSearchBloc>().add(
                  SearchQueryChanged(query, widget.sectionType),
                );
              }
              setState(() {});
            },
            cursorColor: primaryColor,
            selectionControls: materialTextSelectionHandleControls,
            decoration: InputDecoration(
              hintText: _getHintBySectionType(widget.sectionType),
              hintStyle: textStyles.searchFieldHint,
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              prefixIcon: IconButton(
                icon: Icon(Icons.search, color: primaryColor, size: 24),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getHintBySectionType(FeaturedSubpages type) {
    switch (type) {
      case FeaturedSubpages.groups:
        return 'Поиск группы';
      case FeaturedSubpages.teachers:
        return 'Поиск преподавателей';
      case FeaturedSubpages.classes:
        return 'Поиск учебного корпуса';
    }
  }

  Widget _buildFeaturedCards(BuildContext context) {
    final query = _searchController.text;

    if (widget.sectionType == FeaturedSubpages.classes) {
      if (_selectedBuilding != null) {
        return Expanded(child: _buildBuildingSearchResults(context));
      }
    }

    // 1. Пользователь просто нажал на поле
    if (_isFocused && query.isEmpty) {
      return Center(
        child: Text(
          _getInitialSearchText(widget.sectionType),
          style:
              Theme.of(
                context,
              ).extension<AppTypography>()!.featuredPageSubtitle,
        ),
      );
    }

    // 2. Пользователь ввёл что-то → показываем результаты поиска
    if (query.isNotEmpty) {
      return Expanded(child: _buildSearchResults(context));
    }

    // 3. Поле пустое, не в фокусе → показываем избранное (старый виджет)
    return Expanded(child: _buildFavorites(context));
  }

  Widget _buildBuildingSearchResults(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return BlocBuilder<NewSearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const SizedBox.shrink();
        } else if (state is SearchLoading ||
            (state is SearchResultsLoaded &&
                state.results is! List<Featured<Room>>)) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(
            child: Text(
              'Ошибка загрузки',
              style: textStyles.featuredPageSubtitle,
            ),
          );
        } else if (state is SearchResultsLoaded) {
          print('came here');
          _createFAB(state.selectedItem);
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.results.length,
            itemBuilder: (_, index) {
              final item = state.results[index];
              final isSelected = item == state.selectedItem;
              final displayText = _getEntityTextByType(item);
              final isFeatured = item.isFeatured;
              return FeaturedCard(
                displayText,
                isChosen: isSelected,
                isFeatured: isFeatured,
                onTap: () {
                  context.read<NewSearchBloc>().add(
                    SearchItemSelected(item, widget.sectionType),
                  );
                  setState(() {});
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFavorites(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    final items = widget.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Избранное', style: textStyles.featuredPageTitle),
        SizedBox(height: 16),
        items.isEmpty
            ? Center(
              child: Text('Пусто', style: textStyles.featuredPageSubtitle),
            )
            : widget.editMode
            ? Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    EditableFeaturedCard(
                      key: ValueKey(widget.items[i]),
                      title: widget.items[i],
                      dragHandle: Icon(Icons.drag_handle, color: Colors.grey),
                      onDelete: () => _deleteItem(i),
                    ),
                ],
              ),
            )
            : Expanded(
              child: ListView.separated(
                key: ValueKey('choose_list'),
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                itemCount: items.length,
                itemBuilder:
                    (_, index) => FeaturedCard(items[index], onTap: () {}),
                separatorBuilder: (_, __) => SizedBox(height: 10),
              ),
            ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    final item = widget.items.removeAt(oldIndex);
    setState(() {
      widget.items.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    });
    if (item is Featured<Group>) {
      context.read<FeaturedBloc>().add(ReorderGroups(oldIndex, newIndex));
    }
    if (item is Featured<Teacher>) {
      context.read<FeaturedBloc>().add(ReorderTeachers(oldIndex, newIndex));
    }
    if (item is Featured<Room>) {
      context.read<FeaturedBloc>().add(ReorderRooms(oldIndex, newIndex));
    }
  }

  void _deleteItem(int index) {
    setState(() => widget.items.removeAt(index));
    final type = widget.sectionType;
    switch (type) {
      case FeaturedSubpages.groups:
        context.read<FeaturedBloc>().add(DeleteGroup(index));
        break;
      case FeaturedSubpages.teachers:
        context.read<FeaturedBloc>().add(DeleteTeacher(index));
        break;
      case FeaturedSubpages.classes:
        context.read<FeaturedBloc>().add(DeleteRoom(index));
        break;
    }
  }

  Widget _buildSearchResults(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return BlocBuilder<NewSearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return Center(child: Text(_getInitialSearchText(widget.sectionType)));
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(
            child: Text(
              'Ошибка: ${state.message}',
              style: textStyles.featuredPageSubtitle,
            ),
          );
        } else if (state is SearchResultsLoaded) {
          if (state.results.isEmpty) {
            return Center(
              child: Text(
                _getNotFoundText(widget.sectionType),
                style: textStyles.featuredPageSubtitle,
              ),
            );
          }
          _createFAB(state.selectedItem);
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.results.length,
            itemBuilder: (_, index) {
              final item = state.results[index];
              final isSelected = item == state.selectedItem;
              final displayText = _getEntityTextByType(item);
              final isFeatured = item.isFeatured;
              return FeaturedCard(
                displayText,
                isChosen: isSelected,
                isFeatured: isFeatured,
                onTap: () {
                  if (widget.sectionType == FeaturedSubpages.classes) {
                    setState(() {
                      _selectedBuilding = item as Featured<Building>;
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<NewSearchBloc>().add(
                        LoadRoomsForBuilding(_selectedBuilding!.entity.id),
                      );
                    });

                    return;
                  }

                  // старая логика для groups/teachers
                  context.read<NewSearchBloc>().add(
                    SearchItemSelected(item, widget.sectionType),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _createFAB(Featured? item) {
    if (item != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('added');
        context.read<ScaffoldUiStateController>().add(
          ScaffoldUiState(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final route = MaterialPageRoute(
                  builder: (_) {
                    return SchedulePage(
                      dayTime: DateTime.now(),
                      featured: item,
                    );
                  },
                );
                await context.read<GlobalNavigationController>().pushToTab(
                  0,
                  route,
                );
                // сбросить FeaturedPage (она находится в табе 1)
                final resetRoute = MaterialPageRoute(
                  builder: (_) => const FeaturedPage(),
                );
                await context.read<GlobalNavigationController>().resetRootInTab(
                  1,
                  resetRoute,
                );
              },
              child: SvgPicture.asset(AppVectors.chechMark),
            ),
          ),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ScaffoldUiStateController>().clearFAB();
      });
    }
  }

  String _getInitialSearchText(FeaturedSubpages type) {
    switch (type) {
      case FeaturedSubpages.groups:
        return 'Начните вводить номер группы';
      case FeaturedSubpages.teachers:
        return 'Начните вводить ФИО преподавателя';
      case FeaturedSubpages.classes:
        return 'Начните вводить номер корпуса';
    }
  }

  String _getNotFoundText(FeaturedSubpages type) {
    switch (type) {
      case FeaturedSubpages.groups:
        return 'Группа не найдена';
      case FeaturedSubpages.teachers:
        return 'Преподаватель не найден';
      case FeaturedSubpages.classes:
        return 'Учебный корпус не найден';
    }
  }

  String _getEntityTextByType(Featured<Entity> item) {
    switch (widget.sectionType) {
      case FeaturedSubpages.groups:
        return (item as Featured<Group>).entity.name;
      case FeaturedSubpages.teachers:
        return (item as Featured<Teacher>).entity.fullName;
      case FeaturedSubpages.classes:
        return item.entity is Building
            ? (item as Featured<Building>).entity.name
            : (item as Featured<Room>).entity.name;
    }
  }
}

enum FeaturedSubpages {
  groups(AppStrings.groupsFeaturedPageTitle),
  teachers(AppStrings.lecturersFeaturedPageTitle),
  classes(AppStrings.classesFeaturedPageTitle);

  final String title;

  const FeaturedSubpages(this.title);
}
