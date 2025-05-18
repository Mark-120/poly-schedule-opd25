part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final SearchScreenType searchType;

  const SearchQueryChanged(this.query, this.searchType);

  @override
  List<Object> get props => [query, searchType];
}

class SearchItemSelected extends SearchEvent {
  final dynamic selectedItem; // Может быть Group или Teacher
  final SearchScreenType searchType;

  const SearchItemSelected(this.selectedItem, this.searchType);

  @override
  List<Object> get props => [selectedItem, searchType];
}

class SaveToFeatured extends SearchEvent {
  const SaveToFeatured();
}
