import 'package:equatable/equatable.dart';

import '../../../domain/entities/room.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadScheduleByGroup extends ScheduleEvent {
  final int groupId;
  final DateTime dayTime;

  const LoadScheduleByGroup({required this.groupId, required this.dayTime});

  @override
  List<Object> get props => [groupId, dayTime];
}

class LoadScheduleByTeacher extends ScheduleEvent {
  final int teacherId;
  final DateTime dayTime;

  const LoadScheduleByTeacher({required this.teacherId, required this.dayTime});

  @override
  List<Object> get props => [teacherId, dayTime];
}

class LoadScheduleByRoom extends ScheduleEvent {
  final RoomId roomId;
  final DateTime dayTime;

  const LoadScheduleByRoom({required this.roomId, required this.dayTime});

  @override
  List<Object> get props => [roomId, dayTime];
}
