import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/usecases/featured_usecases/delete_featured.dart';
import '../../../domain/usecases/featured_usecases/featured_groups/add_featured_group.dart';
import '../../../domain/usecases/featured_usecases/featured_rooms/add_featured_room.dart';
import '../../../domain/usecases/featured_usecases/featured_teachers/add_featured_teacher.dart';
import '../../../domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import '../../../domain/usecases/schedule_usecases/refresh_schedule.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class NewScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final RefreshSchedule refreshSchedule;
  final GetSchedule getSchedule;
  final AddFeaturedGroup addFeaturedGroup;
  final AddFeaturedTeacher addFeaturedTeacher;
  final AddFeaturedRoom addFeaturedRoom;
  final DeleteFeatured deleteFeatured;

  NewScheduleBloc({
    required this.getSchedule,
    required this.addFeaturedGroup,
    required this.addFeaturedTeacher,
    required this.addFeaturedRoom,
    required this.deleteFeatured,
    required this.refreshSchedule,
  }) : super(const ScheduleLoading()) {
    on<LoadScheduleByGroup>(_onLoadScheduleByGroup);
    on<LoadScheduleByTeacher>(_onLoadScheduleByTeacher);
    on<LoadScheduleByRoom>(_onLoadScheduleByRoom);
    on<SaveToFeatured>(_onSaveToFeatured);
    on<DeleteFromFeatured>(_onDeleteFromFeatured);
    on<RefreshScheduleEvent>(_onRefreshSchedule);
  }

  Future<void> _onDeleteFromFeatured(
    DeleteFromFeatured event,
    Emitter<ScheduleState> emit,
  ) async {
    final entity = event.entity;
    try {
      await deleteFeatured(entity.getId());
    } catch (e) {
      emit(ScheduleError('Error deleting from featured: $e'));
    }
  }

  Future<void> _onSaveToFeatured(
    SaveToFeatured event,
    Emitter<ScheduleState> emit,
  ) async {
    final entity = event.entity;

    try {
      if (entity is Group) {
        await addFeaturedGroup(entity);
        return;
      }
      if (entity is Teacher) {
        await addFeaturedTeacher(entity);
        return;
      }
      if (entity is Room) {
        await addFeaturedRoom(entity);
        return;
      }
      throw UnimplementedError();
    } catch (e) {
      emit(ScheduleError('Error saving to featured: $e'));
    }
  }

  Future<void> _onLoadScheduleByGroup(
    LoadScheduleByGroup event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await getSchedule(
        GetScheduleParams(entityId: event.groupId, dayTime: event.dayTime),
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
        GetScheduleParams(entityId: event.teacherId, dayTime: event.dayTime),
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
        GetScheduleParams(entityId: event.roomId, dayTime: event.dayTime),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onRefreshSchedule(
    RefreshScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final week = await refreshSchedule(
        RefreshScheduleParams(entityId: event.entityId, dayTime: event.dayTime),
      );
      emit(ScheduleLoaded(week));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
