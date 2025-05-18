part of 'class_search_bloc.dart';

abstract class ClassSearchEvent extends Equatable {
  const ClassSearchEvent();

  @override
  List<Object> get props => [];
}

class LoadRoomsForBuilding extends ClassSearchEvent {
  final int buildingId;

  const LoadRoomsForBuilding(this.buildingId);

  @override
  List<Object> get props => [buildingId];
}

class SaveSelectedRoomToFeatured extends ClassSearchEvent {
  const SaveSelectedRoomToFeatured();
}

class RoomSelected extends ClassSearchEvent {
  final Room room;

  const RoomSelected(this.room);

  @override
  List<Object> get props => [room];
}
