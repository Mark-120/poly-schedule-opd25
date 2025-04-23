import '../../domain/entities/teacher.dart';

class TeacherModel extends Teacher{
    const TeacherModel({
        required super.id,
        required super.fullName,
    });
    factory TeacherModel.fromJson(Map<String, dynamic> json) {
        return TeacherModel(
        id: json['id'],
        fullName: json['full_name'],
        );
    }
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'full_name': fullName,
        };
    }
}
