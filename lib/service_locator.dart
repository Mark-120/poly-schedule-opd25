import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'core/logger.dart';
import 'data/adapters/building.dart';
import 'data/adapters/date.dart';
import 'data/adapters/entity_id.dart';
import 'data/adapters/group.dart';
import 'data/adapters/last_schedule.dart';
import 'data/adapters/room.dart';
import 'data/adapters/schedule/day.dart';
import 'data/adapters/schedule/lesson.dart';
import 'data/adapters/schedule/week.dart';
import 'data/adapters/teacher.dart';
import 'data/data_sources/cache/cache.dart';
import 'data/data_sources/cache/schedule_key.dart';
import 'data/data_sources/fetch_impl.dart';
import 'data/data_sources/schedule_impl.dart';
import 'data/models/last_schedule.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/last_schedule_repository.dart';
import 'data/repository/schedule_repository.dart';
import 'domain/entities/group.dart';
import 'domain/entities/room.dart';
import 'domain/entities/schedule/week.dart';
import 'domain/entities/teacher.dart';
import 'domain/repositories/featured_repository.dart';
import 'domain/repositories/last_schedule_repository.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/usecases/featured_usecases/featured_groups/add_featured_group.dart';
import 'domain/usecases/featured_usecases/featured_groups/get_featured_groups.dart';
import 'domain/usecases/featured_usecases/featured_groups/set_featured_groups.dart';
import 'domain/usecases/featured_usecases/featured_rooms/add_featured_room.dart';
import 'domain/usecases/featured_usecases/featured_rooms/get_featured_rooms.dart';
import 'domain/usecases/featured_usecases/featured_rooms/set_featured_rooms.dart';
import 'domain/usecases/featured_usecases/featured_teachers/add_featured_teacher.dart';
import 'domain/usecases/featured_usecases/featured_teachers/get_featured_teachers.dart';
import 'domain/usecases/featured_usecases/featured_teachers/set_featured_teachers.dart';
import 'domain/usecases/last_schedule_usecases/save_last_schedule.dart';
import 'domain/usecases/schedule_usecases/find_groups.dart';
import 'domain/usecases/schedule_usecases/find_teachers.dart';
import 'domain/usecases/schedule_usecases/get_all_buildings.dart';
import 'domain/usecases/schedule_usecases/get_rooms_of_building.dart';
import 'domain/usecases/schedule_usecases/get_schedule_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<AppLogger>(
    () => kDebugMode ? DevLogger() : ProdLogger(),
  );

  // UseCases
  sl.registerLazySingleton(() => GetSchedule(sl()));
  sl.registerLazySingleton(() => FindGroups(sl()));
  sl.registerLazySingleton(() => FindTeachers(sl()));
  sl.registerLazySingleton(() => GetAllBuildings(sl()));
  sl.registerLazySingleton(() => GetRoomsOfBuilding(sl()));

  sl.registerLazySingleton(() => GetFeaturedGroups(sl()));
  sl.registerLazySingleton(() => SetFeaturedGroups(sl()));
  sl.registerLazySingleton(() => AddFeaturedGroup(sl()));
  sl.registerLazySingleton(() => GetFeaturedTeachers(sl()));
  sl.registerLazySingleton(() => SetFeaturedTeachers(sl()));
  sl.registerLazySingleton(() => AddFeaturedTeacher(sl()));
  sl.registerLazySingleton(() => GetFeaturedRooms(sl()));
  sl.registerLazySingleton(() => SetFeaturedRooms(sl()));
  sl.registerLazySingleton(() => AddFeaturedRoom(sl()));

  sl.registerLazySingleton(() => SaveLastSchedule(sl()));
  sl.registerLazySingleton(() => GetLastSchedule(sl()));

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      fetchDataSource: sl<FetchRemoteDataSourceImpl>(),
      scheduleDataSource: sl<CacheDataSource>(),
    ),
  );

  sl.registerLazySingleton<FeaturedRepository>(
    () => FeaturedRepositorySourceImpl(
      featuredGroups: Hive.box<Group>('featured_groups'),
      featuredTeachers: Hive.box<Teacher>('featured_teachers'),
      featuredRooms: Hive.box<Room>('featured_rooms'),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<LastScheduleRepository>(
    () => LastScheduleRepositoryImpl(
      Hive.box<LastSchedule>('last_schedule'),
      logger: sl(),
    ),
  );

  // Hive
  await Hive.initFlutter();

  Hive.registerAdapter(EntityIdAdapter());
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
  Hive.registerAdapter(LastScheduleAdapter());

  await Hive.openBox<LastSchedule>('last_schedule');

  await Hive.openBox<(Week, DateTime)>('schedule_cache');

  await Hive.openBox<Group>('featured_groups');
  await Hive.openBox<Teacher>('featured_teachers');
  await Hive.openBox<Room>('featured_rooms');

  sl.registerSingleton<HiveCache<Week, ScheduleKey>>(
    HiveCache<Week, ScheduleKey>(
      box: Hive.box<(Week, DateTime)>('schedule_cache'),
      entriesCount: 30,
      logger: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton(
    () => CacheDataSource(
      prevDataSource: sl<RemoteScheduleDataSourceImpl>(),
      scheduleCache: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RemoteScheduleDataSourceImpl(client: sl(), logger: sl()),
  );
  sl.registerLazySingleton<FetchRemoteDataSourceImpl>(
    () => FetchRemoteDataSourceImpl(client: sl(), logger: sl()),
  );
}
