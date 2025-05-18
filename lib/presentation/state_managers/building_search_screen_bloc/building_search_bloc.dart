import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/building.dart';
import '../../../domain/usecases/schedule_usecases/get_all_buildings.dart';

part 'building_search_event.dart';
part 'building_search_state.dart';

class BuildingSearchBloc
    extends Bloc<BuildingSearchEvent, BuildingSearchState> {
  final GetAllBuildings getAllBuildings;

  BuildingSearchBloc({required this.getAllBuildings})
    : super(BuildingSearchInitial()) {
    on<LoadBuildings>(_onLoadBuildings);
    on<BuildingSelected>(_onBuildingSelected);
  }

  Future<void> _onLoadBuildings(
    LoadBuildings event,
    Emitter<BuildingSearchState> emit,
  ) async {
    emit(BuildingSearchLoading());
    try {
      final buildings = await getAllBuildings();
      emit(BuildingSearchLoaded(buildings));
    } catch (e) {
      emit(BuildingSearchError(e.toString()));
    }
  }

  void _onBuildingSelected(
    BuildingSelected event,
    Emitter<BuildingSearchState> emit,
  ) {
    if (state is BuildingSearchLoaded) {
      final currentState = state as BuildingSearchLoaded;
      emit(currentState.copyWith(selectedBuilding: event.building));
    }
  }
}
