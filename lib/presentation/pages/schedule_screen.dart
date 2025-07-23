import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/day.dart';
import '../../domain/entities/schedule/week.dart';
import '../../core/date_formater.dart';
import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../service_locator.dart';
import '../state_managers/featured_screen_bloc/featured_bloc.dart';
import '../state_managers/schedule_screen_bloc/schedule_bloc.dart';
import '../state_managers/schedule_screen_bloc/schedule_event.dart';
import '../state_managers/schedule_screen_bloc/schedule_state.dart';
import '../widgets/day_section.dart';
import 'featured_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final ScheduleType type;
  final dynamic id;
  final DateTime initialDayTime;
  final String bottomTitle;

  const ScheduleScreen._({
    super.key,
    required this.type,
    this.id,
    required this.initialDayTime,
    required this.bottomTitle,
  });

  factory ScheduleScreen.group({
    Key? key,
    required int groupId,
    required DateTime dayTime,
    required String bottomTitle,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.group,
      id: groupId,
      initialDayTime: dayTime,
      bottomTitle: bottomTitle,
    );
  }

  factory ScheduleScreen.teacher({
    Key? key,
    required int teacherId,
    required DateTime dayTime,
    required String bottomTitle,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.teacher,
      id: teacherId,
      initialDayTime: dayTime,
      bottomTitle: bottomTitle,
    );
  }

  factory ScheduleScreen.room({
    Key? key,
    required RoomId roomId,
    required DateTime dayTime,
    required String bottomTitle,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.classroom,
      id: roomId,
      initialDayTime: dayTime,
      bottomTitle: bottomTitle,
    );
  }

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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

  final PageController _pageController = PageController(initialPage: 1);
  final List<DateTime> _weekDates = [];
  final List<GlobalKey> _pageKeys = [];

  @override
  void initState() {
    super.initState();
    _weekDates.addAll([
      widget.initialDayTime.subtract(const Duration(days: 7)),
      widget.initialDayTime,
      widget.initialDayTime.add(const Duration(days: 7)),
    ]);
    _pageKeys.addAll([GlobalKey(), GlobalKey(), GlobalKey()]);
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final currentPage = _pageController.page!.round();
    if (currentPage == 0) {
      setState(() {
        _weekDates.insert(
          0,
          _weekDates.first.subtract(const Duration(days: 7)),
        );
        _pageKeys.insert(0, GlobalKey());
      });
      _pageController.jumpToPage(1);
    } else if (currentPage == _weekDates.length - 1) {
      setState(() {
        _weekDates.add(_weekDates.last.add(const Duration(days: 7)));
        _pageKeys.add(GlobalKey());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _weekDates.length,
      itemBuilder: (context, index) {
        return _SchedulePage(
          key: _pageKeys[index],
          type: widget.type,
          id: widget.id,
          dayTime: _weekDates[index],
          onSwipeLeft: _onSwipeLeft,
          onSwipeRight: _onSwipeRight,
          bottomTitle: widget.bottomTitle,
        );
      },
    );
  }
}

class _SchedulePage extends StatelessWidget {
  final ScheduleType type;
  final dynamic id;
  final DateTime dayTime;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final String bottomTitle;

  const _SchedulePage({
    required Key key,
    required this.type,
    this.id,
    required this.dayTime,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.bottomTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ScheduleBloc(
            getScheduleByGroup: sl<GetScheduleByGroup>(),
            getScheduleByTeacher: sl<GetScheduleByTeacher>(),
            getScheduleByRoom: sl<GetScheduleByRoom>(),
          )..add(_createEvent()),
      child: _ScheduleView(
        dayTime: dayTime,
        onSwipeLeft: onSwipeLeft,
        onSwipeRight: onSwipeRight,
        bottomTitle: bottomTitle,
      ),
    );
  }

  ScheduleEvent _createEvent() {
    switch (type) {
      case ScheduleType.group:
        return LoadScheduleByGroup(groupId: id, dayTime: dayTime);
      case ScheduleType.teacher:
        return LoadScheduleByTeacher(teacherId: id, dayTime: dayTime);
      case ScheduleType.classroom:
        return LoadScheduleByRoom(roomId: id, dayTime: dayTime);
    }
  }
}

class _ScheduleView extends StatelessWidget {
  final DateTime dayTime;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final String bottomTitle;

  const _ScheduleView({
    required this.dayTime,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.bottomTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: onSwipeRight,
        ),
        title: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            return _buildAppBarTitle(context, state);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: context.appTheme.iconColor,
            ),
            onPressed: onSwipeLeft,
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) onSwipeRight();
          if (details.primaryVelocity! < 0) onSwipeLeft();
        },
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
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
        ),
      ),
      bottomNavigationBar: _bottomAppBar(context, bottomTitle),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, ScheduleState state) {
    if (state is ScheduleLoaded) {
      final textStyles = AppTextStylesProvider.of(context);
      final week = state.week;

      return Column(
        children: [
          Text(
            '${DateFormater.showShortDateToUser(week.dateStart)} - ${DateFormater.showShortDateToUser(week.dateEnd)}',
            style: textStyles.titleAppbar,
          ),
          Text(
            week.isOdd ? AppStrings.oddWeek : AppStrings.evenWeek,
            style: textStyles.subtitleAppbar,
          ),
        ],
      );
    } else if (state is ScheduleLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
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

Widget _bottomAppBar(BuildContext context, String title) {
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

enum ScheduleType { group, teacher, classroom }
