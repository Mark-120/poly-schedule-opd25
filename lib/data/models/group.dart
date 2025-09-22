import '../../domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({required super.id, required super.name});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(id: GroupId(json['id']), name: json['name']);
  }
}
