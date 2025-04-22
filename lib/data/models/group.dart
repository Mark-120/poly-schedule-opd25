import '../../domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.facultyId,
    required super.name,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      facultyId: json["faculty"]['id'],
      name: json['name'],
    );
  }
}