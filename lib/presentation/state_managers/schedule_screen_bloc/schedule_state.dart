import 'package:equatable/equatable.dart';

import '../../../domain/entities/schedule/week.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleLoaded extends ScheduleState {
  final Week week;

  const ScheduleLoaded(this.week);

  @override
  List<Object> get props => [week];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}
