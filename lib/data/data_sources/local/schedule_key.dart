import 'package:equatable/equatable.dart';

import '../../../domain/entities/entity_id.dart';

class ScheduleKey extends Equatable {
  final EntityId id;
  final DateTime dateTime;
  const ScheduleKey(this.id, this.dateTime);

  @override
  String toString() {
    return '${id.toUniqueString()},${dateTime.toString()}';
  }

  factory ScheduleKey.parse(String string) {
    int split = string.lastIndexOf(',');

    return ScheduleKey(
      EntityId.parseUnique(string.substring(0, split - 1)),
      DateTime.parse(string.substring(split)),
    );
  }

  @override
  List<Object?> get props => [id, dateTime];
}
