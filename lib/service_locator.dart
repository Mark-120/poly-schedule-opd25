import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:poly_scheduler/data/data_sources/cache.dart';
import 'package:poly_scheduler/data/data_sources/remote.dart';
import 'package:poly_scheduler/data/repository/schedule_repository.dart';
import 'package:poly_scheduler/domain/repositories/schedule_repository.dart';
import 'package:poly_scheduler/domain/usecases/get_schedule_usecases.dart';
import 'package:poly_scheduler/presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
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

  await Future.wait([
    Hive.openBox<(Week, DateTime)>('group_schedule_cache'),
    Hive.openBox<(Week, DateTime)>('room_schedule_cache'),
    Hive.openBox<(Week, DateTime)>('teacher_schedule_cache'),
  ]);

  sl.registerSingleton<HiveCache<Week, (int, DateTime)>>(
    HiveCache<Week, (int, DateTime)>(
      box: Hive.box<(Week, DateTime)>('group_schedule_cache'),
      entriesCount: 30,
    ),
    instanceName: 'groupCache',
  );

  sl.registerSingleton<HiveCache<Week, (RoomId, DateTime)>>(
    HiveCache<Week, (RoomId, DateTime)>(
      box: Hive.box<(Week, DateTime)>('room_schedule_cache'),
      entriesCount: 30,
    ),
  );

  sl.registerSingleton<HiveCache<Week, (int, DateTime)>>(
    HiveCache<Week, (int, DateTime)>(
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
      roomScheduleCache: sl<HiveCache<Week, (RoomId, DateTime)>>(),
      teacherScheduleCache: sl(instanceName: 'teacherCache'),
    ),
  );

  sl.registerLazySingleton(() => RemoteDataSourceImpl(client: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
