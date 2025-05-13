import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/day.dart';
import '../../domain/entities/schedule/week.dart';
import '../../core/date_formater.dart';
import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/app_strings.dart';
import '../../core/presentation/theme_extension.dart';
import '../state_managers/schedule_screen_bloc/schedule_bloc.dart';
import '../state_managers/schedule_screen_bloc/schedule_event.dart';
import '../state_managers/schedule_screen_bloc/schedule_state.dart';
import '../widgets/day_section.dart';
import 'featured_screen.dart';
import 'settings_screen.dart';

class ScheduleScreen extends StatelessWidget {
  final ScheduleType type;
  final int? groupId;
  final int? teacherId;
  final RoomId? roomId;
  final DateTime dayTime;

  const ScheduleScreen._({
    super.key,
    required this.type,
    this.groupId,
    this.teacherId,
    this.roomId,
    required this.dayTime,
  }) : assert(
         (type == ScheduleType.group && groupId != null) ||
             (type == ScheduleType.teacher && teacherId != null) ||
             (type == ScheduleType.classroom && roomId != null),
         'Invalid combination of type and IDs',
       );

  factory ScheduleScreen.group({
    Key? key,
    required int groupId,
    required DateTime dayTime,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.group,
      groupId: groupId,
      dayTime: dayTime,
    );
  }

  factory ScheduleScreen.teacher({
    Key? key,
    required int teacherId,
    required DateTime dayTime,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.teacher,
      teacherId: teacherId,
      dayTime: dayTime,
    );
  }

  factory ScheduleScreen.room({
    Key? key,
    required RoomId roomId,
    required DateTime dayTime,
  }) {
    return ScheduleScreen._(
      key: key,
      type: ScheduleType.classroom,
      roomId: roomId,
      dayTime: dayTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ScheduleType.group:
        BlocProvider.of<ScheduleBloc>(
          context,
        ).add(LoadScheduleByGroup(groupId: groupId!, dayTime: dayTime));
      case ScheduleType.teacher:
        BlocProvider.of<ScheduleBloc>(
          context,
        ).add(LoadScheduleByTeacher(teacherId: teacherId!, dayTime: dayTime));
      case ScheduleType.classroom:
        BlocProvider.of<ScheduleBloc>(
          context,
        ).add(LoadScheduleByRoom(roomId: roomId!, dayTime: dayTime));
    }
    return const _ScheduleView();
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: () {},
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
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ScheduleError) {
            return ErrorWidget(state.message);
          } else if (state is ScheduleLoaded) {
            return _LoadedScheduleBody(week: state.week);
          } else {
            return ErrorWidget('Что-то непонятное');
          }
        },
      ),
      bottomNavigationBar: _bottomAppBar(context),
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

Widget _bottomAppBar(BuildContext context) {
  final textStyles = AppTextStylesProvider.of(context);
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: context.appTheme.iconColor,
          ),
          iconSize: 28,
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
        ),
        Text('5130903/30003', style: textStyles.titleBottomAppBar),
        IconButton(
          icon: Icon(
            Icons.star_outline_outlined,
            color: context.appTheme.iconColor,
          ),
          iconSize: 28,
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeaturedScreen()),
              ),
        ),
      ],
    ),
  );
}

enum ScheduleType { group, teacher, classroom }
