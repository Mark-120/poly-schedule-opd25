import 'package:equatable/equatable.dart';

import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadScheduleByGroup extends ScheduleEvent {
  final GroupId groupId;
  final DateTime dayTime;

  const LoadScheduleByGroup({required this.groupId, required this.dayTime});

  @override
  List<Object> get props => [groupId, dayTime];
}

class LoadScheduleByTeacher extends ScheduleEvent {
  final TeacherId teacherId;
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
