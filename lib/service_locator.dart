import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/adapters/building.dart';
import 'data/adapters/date.dart';
import 'data/adapters/group.dart';
import 'data/adapters/room.dart';
import 'data/adapters/schedule/lesson.dart';
import 'data/adapters/schedule/week.dart';
import 'data/adapters/schedule/day.dart';
import 'data/adapters/teacher.dart';
import 'data/data_sources/cache.dart';
import 'data/data_sources/remote.dart';
import 'data/repository/schedule_repository.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/usecases/get_schedule_usecases.dart';
import 'presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'domain/entities/room.dart';
import 'domain/entities/schedule/week.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //State managers
  sl.registerFactory(
    () => ScheduleBloc(getScheduleByGroup: sl<GetScheduleByGroup>()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetScheduleByGroup(sl()));
  sl.registerLazySingleton(() => GetScheduleByTeacher(sl()));
  sl.registerLazySingleton(() => GetScheduleByRoom(sl()));

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(prevDataSource: sl<CacheDataSource>()),
  );

  // Hive
  await Hive.initFlutter();

  Hive.registerAdapter(DateAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(RoomIdAdapter());
  Hive.registerAdapter(BuildingAdapter());
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(WeekAdapter());
  Hive.registerAdapter(WeekDateAdapter());

  await Hive.openBox<(Week, DateTime)>('group_schedule_cache');
  await Hive.openBox<(Week, DateTime)>('room_schedule_cache');
  await Hive.openBox<(Week, DateTime)>('teacher_schedule_cache');

  sl.registerSingleton<HiveCache<Week, KeySchedule<int>>>(
    HiveCache<Week, KeySchedule<int>>(
      box: Hive.box<(Week, DateTime)>('group_schedule_cache'),
      entriesCount: 30,
    ),
    instanceName: 'groupCache',
  );

  sl.registerSingleton<HiveCache<Week, KeySchedule<RoomId>>>(
    HiveCache<Week, KeySchedule<RoomId>>(
      box: Hive.box<(Week, DateTime)>('room_schedule_cache'),
      entriesCount: 30,
    ),
  );

  sl.registerSingleton<HiveCache<Week, KeySchedule<int>>>(
    HiveCache<Week, KeySchedule<int>>(
      box: Hive.box<(Week, DateTime)>('teacher_schedule_cache'),
      entriesCount: 30,
    ),
    instanceName: 'teacherCache',
  );

  // Data Sources
  sl.registerLazySingleton(
    () => CacheDataSource(
      prevDataSource: sl<RemoteDataSourceImpl>(),
      groupScheduleCache: sl(instanceName: 'groupCache'),
      roomScheduleCache: sl<HiveCache<Week, KeySchedule<RoomId>>>(),
      teacherScheduleCache: sl(instanceName: 'teacherCache'),
    ),
  );

  sl.registerLazySingleton(() => RemoteDataSourceImpl(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
