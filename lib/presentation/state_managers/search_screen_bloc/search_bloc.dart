// search_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/group.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/usecases/featured_usecases/featured_groups/add_featured_group.dart';
import '../../../domain/usecases/featured_usecases/featured_teachers/add_featured_teacher.dart';
import '../../../domain/usecases/schedule_usecases/find_groups.dart';
import '../../../domain/usecases/schedule_usecases/find_teachers.dart';
import '../../pages/search_screen.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FindGroups findGroups;
  final FindTeachers findTeachers;
  final AddFeaturedGroup addFeaturedGroup;
  final AddFeaturedTeacher addFeaturedTeacher;

  SearchBloc({
    required this.findGroups,
    required this.findTeachers,
    required this.addFeaturedGroup,
    required this.addFeaturedTeacher,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchItemSelected>(_onSearchItemSelected);
    on<SaveToFeatured>(_onSaveToFeatured);
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
      List<dynamic> results;
      if (event.searchType == SearchScreenType.groups) {
        results = await findGroups(event.query);
      } else {
        results = await findTeachers(event.query);
      }

      emit(SearchResultsLoaded(results, event.searchType));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onSearchItemSelected(
    SearchItemSelected event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchResultsLoaded) {
      final currentState = state as SearchResultsLoaded;
      emit(currentState.copyWith(selectedItem: event.selectedItem));
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
      if (currentState.searchType == SearchScreenType.groups) {
        await addFeaturedGroup(currentState.selectedItem as Group);
      } else {
        await addFeaturedTeacher(currentState.selectedItem as Teacher);
      }
    } catch (e) {
      // Можно добавить обработку ошибок
      emit(SearchError('Error saving to featured: $e'));
    }
  }
}

extension on SearchResultsLoaded {
  SearchState copyWith({
    List<dynamic>? results,
    SearchScreenType? searchType,
    dynamic selectedItem,
  }) {
    return SearchResultsLoaded(
      results ?? this.results,
      searchType ?? this.searchType,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}
