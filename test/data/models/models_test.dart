import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/data/models/teacher.dart';
import '../../../lib/domain/entities/teacher.dart';

void main() {
  group('Equality Check', () {
    test('teacher', () {
      expect(
        TeacherModel(id: TeacherId(1), fullName: '1'),
        TeacherModel(id: TeacherId(1), fullName: '1'),
      );
    });

    test('teacherJson', () {
      var a = TeacherModel.fromJson(
        jsonDecode('''{
    "id": 2,
    "full_name": "2"
    }'''),
      );
      var b = TeacherModel.fromJson(
        jsonDecode('''{
    "id": 2,
    "full_name": "2"
    }'''),
      );
      expect(a, b);
    });
  });
}
