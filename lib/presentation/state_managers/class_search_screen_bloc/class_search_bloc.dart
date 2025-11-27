import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/featured.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/usecases/featured_usecases/featured_rooms/add_featured_room.dart';
import '../../../domain/usecases/schedule_usecases/get_rooms_of_building.dart';

part 'class_search_event.dart';
part 'class_search_state.dart';

class ClassSearchBloc extends Bloc<ClassSearchEvent, ClassSearchState> {
  final GetRoomsOfBuilding getRoomsOfBuilding;
  final AddFeaturedRoom addFeaturedRoom;

  ClassSearchBloc({
    required this.getRoomsOfBuilding,
    required this.addFeaturedRoom,
  }) : super(ClassSearchInitial()) {
    on<LoadRoomsForBuilding>(
      _onLoadRoomsForBuilding,
      transformer: restartable(),
    );
    on<RoomSelected>(_onRoomSelected);
    on<SaveSelectedRoomToFeatured>(_onSaveSelectedRoomToFeatured);
  }

  Future<void> _onLoadRoomsForBuilding(
    LoadRoomsForBuilding event,
    Emitter<ClassSearchState> emit,
  ) async {
    emit(ClassSearchLoading());
    try {
      final rooms = await getRoomsOfBuilding(event.buildingId);
      emit(ClassSearchLoaded(rooms, buildingId: event.buildingId));
    } catch (e) {
      emit(ClassSearchError(e.toString()));
    }
  }

  Future<void> _onSaveSelectedRoomToFeatured(
    SaveSelectedRoomToFeatured event,
    Emitter<ClassSearchState> emit,
  ) async {
    if (state is! ClassSearchLoaded) return;
    final currentState = state as ClassSearchLoaded;
    if (currentState.selectedRoom == null) return;

    try {
      await addFeaturedRoom(currentState.selectedRoom!);
    } catch (e) {
      emit(ClassSearchError('Error saving room to featured: $e'));
    }
  }

  void _onRoomSelected(RoomSelected event, Emitter<ClassSearchState> emit) {
    if (state is ClassSearchLoaded) {
      final currentState = state as ClassSearchLoaded;
      emit(currentState.copyWith(selectedRoom: event.room));
    }
  }
}
