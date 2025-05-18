part of 'class_search_bloc.dart';

abstract class ClassSearchState extends Equatable {
  const ClassSearchState();

  @override
  List<Object> get props => [];
}

class ClassSearchInitial extends ClassSearchState {}

class ClassSearchLoading extends ClassSearchState {}

class ClassSearchLoaded extends ClassSearchState {
  final List<Room> rooms;
  final int buildingId;
  final Room? selectedRoom;

  const ClassSearchLoaded(
    this.rooms, {
    required this.buildingId,
    this.selectedRoom,
  });

  ClassSearchLoaded copyWith({
    List<Room>? rooms,
    Room? selectedRoom,
    int? buildingId,
  }) {
    return ClassSearchLoaded(
      rooms ?? this.rooms,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      buildingId: buildingId ?? this.buildingId,
    );
  }

  @override
  List<Object> get props => [rooms, selectedRoom ?? ''];
}

class ClassSearchError extends ClassSearchState {
  final String message;

  const ClassSearchError(this.message);

  @override
  List<Object> get props => [message];
}
