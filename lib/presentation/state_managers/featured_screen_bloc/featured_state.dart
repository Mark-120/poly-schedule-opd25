// featured_state.dart
part of 'featured_bloc.dart';

abstract class FeaturedState extends Equatable {
  const FeaturedState();

  @override
  List<Object> get props => [];
}

class FeaturedInitial extends FeaturedState {}

class FeaturedLoading extends FeaturedState {}

class FeaturedLoaded extends FeaturedState {
  final List<Group> groups;
  final List<Teacher> teachers;
  final List<Room> rooms;

  const FeaturedLoaded({
    required this.groups,
    required this.teachers,
    required this.rooms,
  });

  FeaturedLoaded copyWith({
    List<Group>? groups,
    List<Teacher>? teachers,
    List<Room>? rooms,
  }) {
    return FeaturedLoaded(
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      rooms: rooms ?? this.rooms,
    );
  }

  @override
  List<Object> get props => [groups, teachers, rooms];
}

class FeaturedError extends FeaturedState {
  final String message;

  const FeaturedError({required this.message});

  @override
  List<Object> get props => [message];
}
