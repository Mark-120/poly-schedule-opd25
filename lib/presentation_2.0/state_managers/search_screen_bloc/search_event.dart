part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class BuildingSelected extends SearchEvent {
  final Building building;

  const BuildingSelected(this.building);

  @override
  List<Object> get props => [building];
}

class LoadRoomsForBuilding extends SearchEvent {
  final int buildingId;

  const LoadRoomsForBuilding(this.buildingId);

  @override
  List<Object> get props => [buildingId];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final FeaturedSubpages searchType;

  const SearchQueryChanged(this.query, this.searchType);

  @override
  List<Object> get props => [query, searchType];
}

class SearchItemSelected extends SearchEvent {
  final Featured selectedItem;
  final FeaturedSubpages searchType;

  const SearchItemSelected(this.selectedItem, this.searchType);

  @override
  List<Object> get props => [selectedItem, searchType];
}

class SaveToFeatured extends SearchEvent {
  const SaveToFeatured();
}
