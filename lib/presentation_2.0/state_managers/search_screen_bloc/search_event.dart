part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final FeaturedSubpages searchType;

  const SearchQueryChanged(this.query, this.searchType);

  @override
  List<Object> get props => [query, searchType];
}

class SearchItemSelected extends SearchEvent {
  final dynamic selectedItem;
  final FeaturedSubpages searchType;

  const SearchItemSelected(this.selectedItem, this.searchType);

  @override
  List<Object> get props => [selectedItem, searchType];
}

class SaveToFeatured extends SearchEvent {
  const SaveToFeatured();
}
