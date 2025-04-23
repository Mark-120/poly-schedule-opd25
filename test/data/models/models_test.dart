import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/domain/entities/teacher.dart';

import '../../../lib/data/models/teacher.dart';




void main() {
  group('Equality Check', () {

  test('teacher', () {
    expect(TeacherModel(id: 1, fullName: '1'), TeacherModel(id: 1, fullName: '1'));
  });

  test('teacherJson', ()  {
    var a = TeacherModel.fromJson(jsonDecode("""{
    "id": 2,
    "full_name": "2"
    }"""));
    var b = TeacherModel.fromJson(jsonDecode("""{
    "id": 2,
    "full_name": "2"
    }"""));
    expect(a, b);
  });
  test('teacherJson', ()  {
    var a = TeacherModel.fromJson(jsonDecode("""{
    "id": 2,
    "full_name": "2"
    }"""));
    var c = Teacher(id: 2, fullName: '2');
    //TeacherModel is a subclass of Teacher, so it's another class and should not be equal
    expect(a, isNot(c));
  });
  

  });
}
