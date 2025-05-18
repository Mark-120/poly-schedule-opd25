part of 'building_search_bloc.dart';

abstract class BuildingSearchState extends Equatable {
  const BuildingSearchState();

  @override
  List<Object> get props => [];
}

class BuildingSearchInitial extends BuildingSearchState {}

class BuildingSearchLoading extends BuildingSearchState {}

class BuildingSearchLoaded extends BuildingSearchState {
  final List<Building> buildings;
  final Building? selectedBuilding;

  const BuildingSearchLoaded(this.buildings, {this.selectedBuilding});

  BuildingSearchLoaded copyWith({
    List<Building>? buildings,
    Building? selectedBuilding,
  }) {
    return BuildingSearchLoaded(
      buildings ?? this.buildings,
      selectedBuilding: selectedBuilding ?? this.selectedBuilding,
    );
  }

  @override
  List<Object> get props => [buildings, selectedBuilding ?? ''];
}

class BuildingSearchError extends BuildingSearchState {
  final String message;

  const BuildingSearchError(this.message);

  @override
  List<Object> get props => [message];
}
