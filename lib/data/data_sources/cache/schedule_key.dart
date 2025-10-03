import 'package:equatable/equatable.dart';

import '../../../domain/entities/entity_id.dart';

class ScheduleKey extends Equatable {
  final EntityId id;
  final DateTime dateTime;
  const ScheduleKey(this.id, this.dateTime);

  @override
  String toString() {
    return '${id.toShortString()},${dateTime.toString()}';
  }

  @override
  List<Object?> get props => [id, dateTime];
}
