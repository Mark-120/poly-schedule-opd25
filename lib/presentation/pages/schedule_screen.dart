import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/date_formater.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/day.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import '../../service_locator.dart';
import '../state_managers/featured_screen_bloc/featured_bloc.dart';
import '../state_managers/schedule_screen_bloc/schedule_bloc.dart';
import '../state_managers/schedule_screen_bloc/schedule_event.dart';
import '../state_managers/schedule_screen_bloc/schedule_state.dart';
import '../widgets/day_section.dart';
import 'featured_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final EntityId id;
  final DateTime dayTime;
  final String bottomTitle;

  const ScheduleScreen({
    super.key,
    required this.id,
    required this.dayTime,
    required this.bottomTitle,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final PageController _pageController = PageController(initialPage: 49);
  final List<DateTime> _weekDates = [];
  final List<GlobalKey> _pageKeys = [];
  late final ValueNotifier<DateTime> _weekNotifier;
  int _savedPageIndex = 49;

  @override
  void initState() {
    super.initState();
    _addAllWeeks();
    _pageKeys.addAll([for (int i = 0; i < 100; i++) GlobalKey()]);
    _pageController.addListener(_onPageChanged);
    _weekNotifier = ValueNotifier(widget.dayTime);
  }

  void _addAllWeeks() {
    _weekDates.add(widget.dayTime);
    for (int i = 0; i < 49; i++) {
      _weekDates.insert(0, _weekDates.first.subtract(const Duration(days: 7)));
    }
    for (int i = 0; i < 50; i++) {
      _weekDates.add(_weekDates.last.add(const Duration(days: 7)));
    }
  }

  void _onPageChanged() {
    final currentPageIndex = _pageController.page!.round();
    if (currentPageIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _weekDates.insert(
            0,
            _weekDates.first.subtract(const Duration(days: 7)),
          );
          _pageKeys.insert(0, GlobalKey());
          _pageController.jumpToPage(1);
        });
      });
    } else if (currentPageIndex == _weekDates.length - 1) {
      setState(() {
        _weekDates.add(_weekDates.last.add(const Duration(days: 7)));
        _pageKeys.add(GlobalKey());
      });
    }
    if (currentPageIndex != _savedPageIndex) {
      _savedPageIndex = currentPageIndex;
      _weekNotifier.value = _weekDates[_savedPageIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ScheduleWrapper(
      onSwipeLeft: _onSwipeLeft,
      onSwipeRight: _onSwipeRight,
      bottomTitle: widget.bottomTitle,
      weekNotifier: _weekNotifier,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _weekDates.length,
        itemBuilder: (context, index) {
          return BlocProvider(
            create:
                (context) =>
                    ScheduleBloc(getSchedule: sl<GetSchedule>())
                      ..add(_createEvent(widget.id, _weekDates[index])),
            child: _SchedulePage(key: _pageKeys[index]),
          );
        },
      ),
    );
  }

  void _onSwipeLeft() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSwipeRight() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ScheduleEvent _createEvent(EntityId id, DateTime dayTime) {
    if (id.isGroup) {
      return LoadScheduleByGroup(groupId: id.asGroup, dayTime: dayTime);
    } else if (id.isTeacher) {
      return LoadScheduleByTeacher(teacherId: id.asTeacher, dayTime: dayTime);
    } else if (id.isRoom) {
      return LoadScheduleByRoom(roomId: id.asRoom, dayTime: dayTime);
    } else {
      throw UnimplementedError();
    }
  }
}

class _ScheduleWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final String bottomTitle;
  final ValueNotifier<DateTime> weekNotifier;

  const _ScheduleWrapper({
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.bottomTitle,
    required this.weekNotifier,
  });

  @override
  State<_ScheduleWrapper> createState() => _ScheduleWrapperState();
}

class _ScheduleWrapperState extends State<_ScheduleWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: widget.onSwipeRight,
        ),
        title: _buildAppBarTitle(context, widget.weekNotifier),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: context.appTheme.iconColor,
            ),
            onPressed: widget.onSwipeLeft,
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: _buildBottomBar(context, widget.bottomTitle),
    );
  }

  Widget _buildAppBarTitle(
    BuildContext context,
    ValueNotifier<DateTime> weekNotifier,
  ) {
    final textStyles = AppTextStylesProvider.of(context);
    return ValueListenableBuilder<DateTime>(
      valueListenable: weekNotifier,
      builder: (context, week, child) {
        final weekStart = DateFormater.truncDate(week);
        final weekEnd = weekStart.add(Duration(days: 6));
        return Column(
          children: [
            Text(
              '${DateFormater.showShortDateToUser(weekStart)} - ${DateFormater.showShortDateToUser(weekEnd)}',
              style: textStyles.titleAppbar,
            ),
            Text(
              week.isOdd ? AppStrings.oddWeek : AppStrings.evenWeek,
              style: textStyles.subtitleAppbar,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, String title) {
    final textStyles = AppTextStylesProvider.of(context);
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: textStyles.titleBottomAppBar,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star_outline_outlined,
              color: context.appTheme.iconColor,
            ),
            iconSize: 28,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          lazy: false,
                          create:
                              (context) => FeaturedBloc(
                                getFeaturedGroups: sl(),
                                getFeaturedTeachers: sl(),
                                getFeaturedRooms: sl(),
                                setFeaturedGroups: sl(),
                                setFeaturedTeachers: sl(),
                                setFeaturedRooms: sl(),
                                saveLastSchedule: sl(),
                              ),
                          child: FeaturedScreen(),
                        ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _SchedulePage extends StatelessWidget {
  const _SchedulePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ScheduleError) {
          return Center(child: Text(state.message));
        } else if (state is ScheduleLoaded) {
          return _LoadedScheduleBody(week: state.week);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _LoadedScheduleBody extends StatelessWidget {
  final Week week;

  const _LoadedScheduleBody({required this.week});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, Day> daysWithSchedule = {
      for (var e in week.days) e.date: e,
    };
    final daysToShow = List.generate(
      6,
      (i) => week.dateStart.add(Duration(days: i)),
    );

    return ListView.separated(
      itemBuilder: (context, index) {
        final date = daysToShow[index];
        return daySection(
          DateFormater.showDateToUser(date),
          DateFormater.showWeekdayToUser(date),
          daysWithSchedule[date]?.lessons,
          context,
        );
      },
      itemCount: daysToShow.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => SizedBox(height: 16),
    );
  }
}
