import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poly_scheduler/domain/usecases/get_schedule_usecases.dart';
import 'package:poly_scheduler/presentation/state_managers/schedule_screen_bloc/schedule_event.dart';
import 'package:poly_scheduler/presentation/state_managers/schedule_screen_bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetScheduleByGroup getScheduleByGroup;
  // final GetScheduleByTeacher getScheduleByTeacher;
  // final GetScheduleByRoom getScheduleByRoom;

  ScheduleBloc({
    required this.getScheduleByGroup,
    // required this.getScheduleByTeacher,
    // required this.getScheduleByRoom,
  }) : super(const ScheduleLoading()) {
    on<LoadScheduleByGroup>(_onLoadScheduleByGroup);
    // on<LoadScheduleByTeacher>(_onLoadScheduleByTeacher);
    // on<LoadScheduleByRoom>(_onLoadScheduleByRoom);
  }

  Future<void> _onLoadScheduleByGroup(
    LoadScheduleByGroup event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await getScheduleByGroup(
        GetScheduleByGroupParams(
          groupId: event.groupId,
          dayTime: event.dayTime,
        ),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
