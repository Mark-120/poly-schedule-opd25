import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/date_formater.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state.dart';
import '../../core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../core/services/error_handling_service.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/day.dart';
import '../../domain/entities/schedule/week.dart';
import '../../presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
import '../../presentation/state_managers/schedule_screen_bloc/schedule_event.dart';
import '../../presentation/state_managers/schedule_screen_bloc/schedule_state.dart';
import '../../service_locator.dart';
import '../widgets/schedule_day_card.dart';

class SchedulePage extends StatefulWidget {
  static const route = '/schedule';

  final EntityId id;
  final DateTime dayTime;
  final String bottomTitle;

  const SchedulePage({
    super.key,
    required this.id,
    required this.dayTime,
    required this.bottomTitle,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
    return _ScheduleAppBarWrapper(
      onSwipeLeft: _onSwipeLeft,
      onSwipeRight: _onSwipeRight,
      weekNotifier: _weekNotifier,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _weekDates.length,
        itemBuilder: (context, index) {
          return BlocProvider(
            create:
                (context) =>
                    sl<ScheduleBloc>()
                      ..add(_createEvent(widget.id, _weekDates[index])),
            child: _SchedulePage(
              key: _pageKeys[index],
              bottomTitle: widget.bottomTitle,
            ),
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

class _ScheduleAppBarWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final ValueNotifier<DateTime> weekNotifier;

  const _ScheduleAppBarWrapper({
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.weekNotifier,
  });

  @override
  State<_ScheduleAppBarWrapper> createState() => _ScheduleAppBarWrapperState();
}

class _ScheduleAppBarWrapperState extends State<_ScheduleAppBarWrapper> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ScaffoldUiStateController>().update(
        ScaffoldUiState(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.appTheme.iconColor,
              ),
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
        ),
      ),
    );
    return widget.child;
  }

  Widget _buildAppBarTitle(
    BuildContext context,
    ValueNotifier<DateTime> weekNotifier,
  ) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    return ValueListenableBuilder<DateTime>(
      valueListenable: weekNotifier,
      builder: (context, week, child) {
        final weekStart = DateFormater.truncDate(week);
        final weekEnd = weekStart.add(Duration(days: 6));
        return Column(
          children: [
            Text(
              '${DateFormater.showShortDateToUser(weekStart)} - ${DateFormater.showShortDateToUser(weekEnd)}',
              style: textStyles.appBarTitle,
            ),
            Text(
              week.isOdd ? AppStrings.oddWeek : AppStrings.evenWeek,
              style: textStyles.appBarSubtitle,
            ),
          ],
        );
      },
    );
  }
}

class _SchedulePage extends StatelessWidget {
  final String bottomTitle;
  const _SchedulePage({required Key key, required this.bottomTitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ScheduleError) {
          ErrorHandlingService.handleError(context, state.message);
          return Center(
            child: Text(
              AppStrings.errorMessage,
              style: textStyles.emptySchedule,
            ),
          );
        } else if (state is ScheduleLoaded) {
          return Stack(
            children: [
              _LoadedScheduleBody(week: state.week),
              Align(
                alignment: Alignment.bottomCenter,
                child: _bottomBar(context, title: bottomTitle),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _bottomBar(BuildContext context, {required String title}) {
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: Offset(0, -6),
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      height: 38,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: textStyles.bottomBarTitle,
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
            onPressed: () => {},
          ),
        ],
      ),
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

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final date = daysToShow[index];
              return ScheduleDayCard(
                date: DateFormater.showDateToUser(date),
                day: DateFormater.showShortWeekdayToUser(date),
                classes: daysWithSchedule[date]?.lessons,
              );
            },
            itemCount: daysToShow.length,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (context, index) => SizedBox(),
          ),
        ),
        SizedBox(height: 38),
      ],
    );
  }
}

class ScheduleScreenArguments {
  final EntityId id;
  final DateTime dayTime;
  final String bottomTitle;

  const ScheduleScreenArguments({
    required this.id,
    required this.dayTime,
    required this.bottomTitle,
  });
}
