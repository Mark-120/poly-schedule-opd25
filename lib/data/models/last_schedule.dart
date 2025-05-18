class LastSchedule {
  final String type;
  final String id;
  final String title;
  final DateTime lastOpened;

  LastSchedule({
    required this.type,
    required this.id,
    required this.title,
    required this.lastOpened,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'lastOpened': lastOpened.toIso8601String(),
    };
  }

  factory LastSchedule.fromMap(Map<dynamic, dynamic> map) {
    return LastSchedule(
      type: map['type'],
      id: map['id'],
      title: map['title'],
      lastOpened: DateTime.parse(map['lastOpened']),
    );
  }
}
