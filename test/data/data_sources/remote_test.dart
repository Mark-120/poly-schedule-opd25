import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/data/models/schedule/day.dart';
import '../../../lib/data/models/schedule/lesson.dart';
import '../../../lib/data/models/schedule/week.dart';
import '../../../lib/data/data_sources/remote.dart';
import '../../../lib/data/models/building.dart';
import '../../../lib/data/models/teacher.dart';
import '../../../lib/data/models/group.dart';
import '../../../lib/data/models/room.dart';

void main() {
  group('RemoteSourceTestsWithRealHTTP', () {
    test('getAllBuilding', () async {
      final source = RemoteDataSourceImpl(client: http.Client());

      final buildings = await source.getAllBuildings();

      expect(
        buildings.firstWhere((x) => x.id == 11),
        BuildingModel(id: 11, name: 'Главное здание', abbr: "ГЗ", address: ''),
      );
    });
  });

  group('RemoteSourceTestsWithMockHTTP', () {
    test('getAllBuildings', () async {
      final source = RemoteDataSourceImpl(
        client: MockClient((request) async {
          return http.Response("""{
 "buildings": [
  {
   "id": 1,
   "name": "Building 1",
   "abbr": "b 1",
   "address": "k1"
  },
  {
   "id": 2,
   "name": "Building 2",
   "abbr": "b 2",
   "address": "k2"
  }
  ]}""", 200);
        }),
      );

      final buildings = await source.getAllBuildings();

      expect(buildings, [
        BuildingModel(id: 1, name: 'Building 1', abbr: "b 1", address: 'k1'),
        BuildingModel(id: 2, name: 'Building 2', abbr: "b 2", address: 'k2'),
      ]);
    });

    test('findTeachers', () async {
      final source = RemoteDataSourceImpl(
        client: MockClient((request) async {
          if (!request.toString().endsWith('q=teacher')) {
            throw Exception('Wrong query, query is $request');
          }
          return http.Response("""{
 "teachers": [
  {
   "id": 1,
   "full_name": "1"
  },
  {
   "id": 2,
   "full_name": "2"
  }]}""", 200);
        }),
      );

      final teachers = await source.findTeachers('teacher');

      expect(teachers, [
        TeacherModel(id: 1, fullName: '1'),
        TeacherModel(id: 2, fullName: '2'),
      ]);
    });

    test('findGroup', () async {
      final source = RemoteDataSourceImpl(
        client: MockClient((request) async {
          if (!request.toString().endsWith('q=group')) {
            throw Exception('Wrong query, query is $request');
          }
          return http.Response("""{
 "groups": [
  {
   "id": 1,
   "name": "1",
   "faculty": {"id": 1, "name": "Name", "abbr": "N"}
  },
  {
   "id": 2,
   "name": "2",
   "faculty": {"id": 2, "name": "Name2", "abbr": "N2"}
  }]}""", 200);
        }),
      );

      final groups = await source.findGroups('group');

      expect(groups, [
        GroupModel(id: 1, name: '1'),
        GroupModel(id: 2, name: '2'),
      ]);
    });

    test('getAllRoomsOfBuilding', () async {
      BuildingModel building = BuildingModel(
        id: 938,
        name: "build",
        abbr: "bld",
        address: "none",
      );

      final source = RemoteDataSourceImpl(
        client: MockClient((request) async {
          if (!request.toString().contains('938')) {
            throw Exception('Wrong query, query is $request');
          }
          return http.Response.bytes(
            utf8.encode("""{
 "rooms": [
  {
   "id": 1,
   "name": "А"
  },
  {
   "id": 2,
   "name": "2"
  }],
  "building": {
    
  "id": 938,
  "name": "build",
  "abbr": "bld",
  "address": "none"
  }}"""),
            200,
            headers: {'content-type': 'text/plain; charset=utf-8'},
          );
        }),
      );

      final groups = await source.getAllRoomsOfBuilding(building.id);

      expect(groups, [
        RoomModel(id: 2, name: '2', building: building),
        RoomModel(id: 1, name: 'А', building: building),
      ]);
    });
    test('getScheduleByGroup', () async {
      final source = RemoteDataSourceImpl(
        client: MockClient((request) async {
          if (!request.toString().endsWith('1?date=2001-1-1')) {
            throw Exception('Wrong query, query is $request');
          }
          return http.Response.bytes(
            utf8.encode("""{
 "week": {
  "date_start": "2001.01.01",
  "date_end": "2001.01.07",
  "is_odd": true
 },
 "days": [
  {
   "weekday": 1,
   "date": "2001.01.01",
   "lessons": [
    {
     "subject": "Зельеварение",
     "abbr": "Зельеварение",
     "additional_info": "Поток",
     "time_start": "10:00",
     "time_end": "11:40",
     "typeObj": {
      "id": 14,
      "name": "Лекции",
      "abbr": "Лек"
     },
     "groups": [
      {
       "id": 101,
       "name": "10101",
       "faculty": {
        "id": 2,
        "name": "Институт компьютерных наук и кибербезопасности",
        "abbr": "ИКНК"
       }
      },
      {
       "id": 102,
       "name": "10102",
       "faculty": {
        "id": 2,
        "name": "Институт компьютерных наук и кибербезопасности",
        "abbr": "ИКНК"
       }
      }
     ],
     "teachers": [
      {
       "id": 201,
       "full_name": "Северус Снегг"
      }
     ],
     "auditories": [
      {
       "id": 301,
       "name": "Кабинет Зельеварения",
       "building": {
        "id": 25,
        "name": "Школа Чародейства и волшебства Хогвартс",
        "abbr": "Хогвартс",
        "address": "Великобритания"
       }
      }
     ],
     "webinar_url": "",
     "lms_url": "https://dl.spbstu.ru//course/view.php?id=-1"
    }]}]}"""),
            200,
          );
        }),
      );

      final groups = await source.getScheduleByGroup(1, DateTime(2001, 1, 1));

      expect(
        groups,
        WeekModel(
          dateStart: DateTime(2001, 1, 1),
          dateEnd: DateTime(2001, 1, 7),
          isOdd: true,
          days: [
            DayModel(
              date: DateTime(2001, 1, 1),
              lessons: [
                LessonModel(
                  subject: "Зельеварение",
                  type: "Лекции",
                  typeAbbr: "Лек",
                  start: "10:00",
                  end: "11:40",
                  groups: [
                    GroupModel(id: 101, name: "10101"),
                    GroupModel(id: 102, name: "10102"),
                  ],
                  auditories: [
                    RoomModel(
                      id: 301,
                      building: BuildingModel(
                        id: 25,
                        name: "Школа Чародейства и волшебства Хогвартс",
                        abbr: "Хогвартс",
                        address: "Великобритания",
                      ),
                      name: "Кабинет Зельеварения",
                    ),
                  ],
                  teachers: [TeacherModel(id: 201, fullName: "Северус Снегг")],
                  webinarUrl: "",
                  lmsUrl: "https://dl.spbstu.ru//course/view.php?id=-1",
                ),
              ],
            ),
          ],
        ),
      );
    });
  });
}
