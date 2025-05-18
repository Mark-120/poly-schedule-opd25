part of 'building_search_bloc.dart';

abstract class BuildingSearchEvent extends Equatable {
  const BuildingSearchEvent();

  @override
  List<Object> get props => [];
}

class LoadBuildings extends BuildingSearchEvent {}

class BuildingSelected extends BuildingSearchEvent {
  final Building building;

  const BuildingSelected(this.building);

  @override
  List<Object> get props => [building];
}
