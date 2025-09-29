// featured_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/usecases/featured_usecases/featured_groups/get_featured_groups.dart';
import '../../../domain/usecases/featured_usecases/featured_groups/set_featured_groups.dart';
import '../../../domain/usecases/featured_usecases/featured_rooms/get_featured_rooms.dart';
import '../../../domain/usecases/featured_usecases/featured_rooms/set_featured_rooms.dart';
import '../../../domain/usecases/featured_usecases/featured_teachers/get_featured_teachers.dart';
import '../../../domain/usecases/featured_usecases/featured_teachers/set_featured_teachers.dart';
import '../../../domain/usecases/last_schedule_usecases/save_last_schedule.dart';

part 'featured_event.dart';
part 'featured_state.dart';

class FeaturedBloc extends Bloc<FeaturedEvent, FeaturedState> {
  final GetFeaturedGroups getFeaturedGroups;
  final GetFeaturedTeachers getFeaturedTeachers;
  final GetFeaturedRooms getFeaturedRooms;
  final SetFeaturedGroups setFeaturedGroups;
  final SetFeaturedTeachers setFeaturedTeachers;
  final SetFeaturedRooms setFeaturedRooms;
  final SaveLastSchedule saveLastSchedule;

  FeaturedBloc({
    required this.getFeaturedGroups,
    required this.getFeaturedTeachers,
    required this.getFeaturedRooms,
    required this.setFeaturedGroups,
    required this.setFeaturedTeachers,
    required this.setFeaturedRooms,
    required this.saveLastSchedule,
  }) : super(FeaturedInitial()) {
    on<LoadFeaturedData>(_onLoadFeaturedData);
    on<ReorderGroups>(_onReorderGroups);
    on<ReorderTeachers>(_onReorderTeachers);
    on<ReorderRooms>(_onReorderRooms);
    on<DeleteGroup>(_onDeleteGroup);
    on<DeleteTeacher>(_onDeleteTeacher);
    on<DeleteRoom>(_onDeleteRoom);
    on<SaveLastOpenedSchedule>(_onSaveLastOpenedSchedule);
  }

  Future<void> _onLoadFeaturedData(
    LoadFeaturedData event,
    Emitter<FeaturedState> emit,
  ) async {
    emit(FeaturedLoading());
    try {
      final groups = await getFeaturedGroups();
      final teachers = await getFeaturedTeachers();
      final rooms = await getFeaturedRooms();
      emit(FeaturedLoaded(groups: groups, teachers: teachers, rooms: rooms));
    } catch (e) {
      emit(FeaturedError(message: e.toString()));
    }
  }

  Future<void> _onReorderGroups(
    ReorderGroups event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newGroups = List<Group>.from(currentState.groups);
      final item = newGroups.removeAt(event.oldIndex);
      newGroups.insert(event.newIndex, item);

      await setFeaturedGroups(newGroups);
      emit(currentState.copyWith(groups: newGroups));
    }
  }

  Future<void> _onReorderTeachers(
    ReorderTeachers event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newTeachers = List<Teacher>.from(currentState.teachers);
      final item = newTeachers.removeAt(event.oldIndex);
      newTeachers.insert(event.newIndex, item);

      await setFeaturedTeachers(newTeachers);
      emit(currentState.copyWith(teachers: newTeachers));
    }
  }

  Future<void> _onReorderRooms(
    ReorderRooms event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newRooms = List<Room>.from(currentState.rooms);
      final item = newRooms.removeAt(event.oldIndex);
      newRooms.insert(event.newIndex, item);

      await setFeaturedRooms(newRooms);
      emit(currentState.copyWith(rooms: newRooms));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newGroups = List<Group>.from(currentState.groups);
      newGroups.removeAt(event.index);

      await setFeaturedGroups(newGroups);
      emit(currentState.copyWith(groups: newGroups));
    }
  }

  Future<void> _onDeleteTeacher(
    DeleteTeacher event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newTeachers = List<Teacher>.from(currentState.teachers);
      newTeachers.removeAt(event.index);

      await setFeaturedTeachers(newTeachers);
      emit(currentState.copyWith(teachers: newTeachers));
    }
  }

  Future<void> _onDeleteRoom(
    DeleteRoom event,
    Emitter<FeaturedState> emit,
  ) async {
    if (state is FeaturedLoaded) {
      final currentState = state as FeaturedLoaded;
      final newRooms = List<Room>.from(currentState.rooms);
      newRooms.removeAt(event.index);

      await setFeaturedRooms(newRooms);
      emit(currentState.copyWith(rooms: newRooms));
    }
  }

  Future<void> _onSaveLastOpenedSchedule(
    SaveLastOpenedSchedule event,
    Emitter<FeaturedState> emit,
  ) async {
    await saveLastSchedule(type: event.type, id: event.id, title: event.title);
  }
}
