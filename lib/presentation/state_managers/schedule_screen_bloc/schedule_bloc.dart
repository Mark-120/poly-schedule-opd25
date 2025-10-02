import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetSchedule getSchedule;

  ScheduleBloc({required this.getSchedule}) : super(const ScheduleLoading()) {
    on<LoadScheduleByGroup>(_onLoadScheduleByGroup);
    on<LoadScheduleByTeacher>(_onLoadScheduleByTeacher);
    on<LoadScheduleByRoom>(_onLoadScheduleByRoom);
  }

  Future<void> _onLoadScheduleByGroup(
    LoadScheduleByGroup event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await getSchedule(
        GetScheduleParams(
          entityId: EntityId.group(event.groupId),
          dayTime: event.dayTime,
        ),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadScheduleByTeacher(
    LoadScheduleByTeacher event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await getSchedule(
        GetScheduleParams(
          entityId: EntityId.teacher(event.teacherId),
          dayTime: event.dayTime,
        ),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadScheduleByRoom(
    LoadScheduleByRoom event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await getSchedule(
        GetScheduleParams(
          entityId: EntityId.room(event.roomId),
          dayTime: event.dayTime,
        ),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
