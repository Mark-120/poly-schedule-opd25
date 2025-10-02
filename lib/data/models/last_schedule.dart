import '../../domain/entities/entity_id.dart';

class LastSchedule {
  final EntityId id;
  final String title;
  final DateTime lastOpened;

  LastSchedule({
    required this.id,
    required this.title,
    required this.lastOpened,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lastOpened': lastOpened.toIso8601String(),
    };
  }

  factory LastSchedule.fromMap(Map<dynamic, dynamic> map) {
    return LastSchedule(
      id: map['id'],
      title: map['title'],
      lastOpened: DateTime.parse(map['lastOpened']),
    );
  }
}
