// search_bloc.dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/building.dart';
import '../../../domain/entities/featured.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/usecases/featured_usecases/featured_groups/add_featured_group.dart';
import '../../../domain/usecases/featured_usecases/featured_rooms/add_featured_room.dart';
import '../../../domain/usecases/featured_usecases/featured_teachers/add_featured_teacher.dart';
import '../../../domain/usecases/schedule_usecases/find_groups.dart';
import '../../../domain/usecases/schedule_usecases/find_teachers.dart';
import '../../../domain/usecases/schedule_usecases/get_all_buildings.dart';
import '../../../domain/usecases/schedule_usecases/get_rooms_of_building.dart';
import '../../pages/featured_page.dart';

part 'search_event.dart';
part 'search_state.dart';

class NewSearchBloc extends Bloc<SearchEvent, SearchState> {
  final FindGroups findGroups;
  final FindTeachers findTeachers;
  final GetAllBuildings getAllBuildings;
  final GetRoomsOfBuilding getRoomsOfBuilding;
  final AddFeaturedRoom addFeaturedRoom;
  final AddFeaturedGroup addFeaturedGroup;
  final AddFeaturedTeacher addFeaturedTeacher;

  NewSearchBloc({
    required this.findGroups,
    required this.findTeachers,
    required this.getAllBuildings,
    required this.getRoomsOfBuilding,
    required this.addFeaturedRoom,
    required this.addFeaturedGroup,
    required this.addFeaturedTeacher,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: restartable());
    on<SearchItemSelected>(_onSearchItemSelected);
    on<SaveToFeatured>(_onSaveToFeatured);
    on<LoadBuildings>(_onLoadBuildings, transformer: restartable());
    on<BuildingSelected>(_onBuildingSelected);
    on<LoadRoomsForBuilding>(
      _onLoadRoomsForBuilding,
      transformer: restartable(),
    );
  }

  Future<void> _onLoadRoomsForBuilding(
    LoadRoomsForBuilding event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final rooms = await getRoomsOfBuilding(event.buildingId);
      emit(SearchResultsLoaded(rooms, FeaturedSubpages.classes));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      List<Featured> results;
      if (event.searchType == FeaturedSubpages.groups) {
        results = await findGroups(event.query);
      } else {
        results = await findTeachers(event.query);
      }

      emit(SearchResultsLoaded(results, event.searchType));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadBuildings(
    LoadBuildings event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final buildings = await getAllBuildings();
      emit(SearchResultsLoaded(buildings, FeaturedSubpages.classes));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onBuildingSelected(BuildingSelected event, Emitter<SearchState> emit) {
    if (state is SearchResultsLoaded) {
      final currentState = state as SearchResultsLoaded;
      emit(currentState.copyWith(selectedBuilding: event.building));
    }
  }

  void _onSearchItemSelected(
    SearchItemSelected event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchResultsLoaded) {
      final currentState = state as SearchResultsLoaded;
      if (currentState.selectedItem == event.selectedItem) {
        print('came in');
        emit(currentState.unchooseItem());
      } else {
        emit(currentState.copyWith(selectedItem: event.selectedItem));
      }
    }
  }

  Future<void> _onSaveToFeatured(
    SaveToFeatured event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchResultsLoaded) return;

    final currentState = state as SearchResultsLoaded;
    if (currentState.selectedItem == null) return;

    try {
      switch (currentState.searchType) {
        case FeaturedSubpages.groups:
          await addFeaturedGroup(currentState.selectedItem as Group);
        case FeaturedSubpages.teachers:
          await addFeaturedTeacher(currentState.selectedItem as Teacher);
        case FeaturedSubpages.classes:
          await addFeaturedRoom(currentState.selectedItem as Room);
      }
    } catch (e) {
      // Можно добавить обработку ошибок
      emit(SearchError('Error saving to featured: $e'));
    }
  }
}

extension on SearchResultsLoaded {
  SearchState copyWith({
    List<Featured>? results,
    FeaturedSubpages? searchType,
    Featured? selectedItem,
    Building? selectedBuilding,
  }) {
    return SearchResultsLoaded(
      results ?? this.results,
      searchType ?? this.searchType,
      selectedItem: selectedItem ?? this.selectedItem,
      selectedBuilding: selectedBuilding ?? this.selectedBuilding,
    );
  }

  SearchState unchooseItem() {
    return SearchResultsLoaded(results, searchType, selectedItem: null);
  }
}
