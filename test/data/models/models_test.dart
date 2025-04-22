import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/data/models/room.dart';
import '../../../lib/data/models/building.dart';
import '../../../lib/data/models/group.dart';
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

  });
}
