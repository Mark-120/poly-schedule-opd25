// featured_event.dart
part of 'featured_bloc.dart';

abstract class FeaturedEvent extends Equatable {
  const FeaturedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeaturedData extends FeaturedEvent {}

class ReorderGroups extends FeaturedEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderGroups(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class ReorderTeachers extends FeaturedEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderTeachers(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class ReorderRooms extends FeaturedEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderRooms(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class DeleteGroup extends FeaturedEvent {
  final int index;

  const DeleteGroup(this.index);

  @override
  List<Object> get props => [index];
}

class DeleteTeacher extends FeaturedEvent {
  final int index;

  const DeleteTeacher(this.index);

  @override
  List<Object> get props => [index];
}

class DeleteRoom extends FeaturedEvent {
  final int index;

  const DeleteRoom(this.index);

  @override
  List<Object> get props => [index];
}
