part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

// search_state.dart
class SearchResultsLoaded extends SearchState {
  final List<Featured> results;
  final FeaturedSubpages searchType;
  final Building? selectedBuilding;
  final Featured? selectedItem; // Добавляем выбранный элемент в состояние

  const SearchResultsLoaded(
    this.results,
    this.searchType, {
    this.selectedBuilding,
    this.selectedItem,
  });

  @override
  List<Object> get props => [
    results,
    searchType,
    selectedBuilding ?? '',
    selectedItem ?? '',
  ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
