import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'core/logger.dart';
import 'core/services/last_schedule_service.dart';
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
import 'data/data_sources/intermediate/prefetch.dart';
import 'data/data_sources/local/cache.dart';
import 'data/data_sources/local/hive_cache.dart';
import 'data/data_sources/local/local.dart';
import 'data/data_sources/local/schedule_key.dart';
import 'data/data_sources/remote/fetch_impl.dart';
import 'data/data_sources/remote/schedule_impl.dart';
import 'data/models/last_schedule.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/fetch_repository.dart';
import 'data/repository/last_schedule_repository.dart';
import 'data/repository/schedule_repository.dart';
import 'domain/entities/group.dart';
import 'domain/entities/room.dart';
import 'domain/entities/schedule/week.dart';
import 'domain/entities/teacher.dart';
import 'domain/repositories/featured_repository.dart';
import 'domain/repositories/fetch_repository.dart';
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
import 'domain/usecases/featured_usecases/is_featured.dart';
import 'domain/usecases/last_schedule_usecases/save_last_schedule.dart';
import 'domain/usecases/schedule_usecases/find_groups.dart';
import 'domain/usecases/schedule_usecases/find_teachers.dart';
import 'domain/usecases/schedule_usecases/get_all_buildings.dart';
import 'domain/usecases/schedule_usecases/get_rooms_of_building.dart';
import 'domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import 'domain/usecases/schedule_usecases/on_app_start.dart';
import 'presentation/state_managers/building_search_screen_bloc/building_search_bloc.dart';
import 'presentation/state_managers/class_search_screen_bloc/class_search_bloc.dart';
import 'presentation/state_managers/featured_screen_bloc/featured_bloc.dart';
import 'presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
import 'presentation/state_managers/search_screen_bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<AppLogger>(
    () => kDebugMode ? DevLogger() : ProdLogger(),
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

  await Hive.openBox<Week>('schedule_local');
  await Hive.openBox<(Week, DateTime)>('schedule_cache');

  await Hive.openBox<Group>('featured_groups');
  await Hive.openBox<Teacher>('featured_teachers');
  await Hive.openBox<Room>('featured_rooms');

  // UseCases
  sl.registerLazySingleton(() => GetSchedule(sl()));
  sl.registerLazySingleton(() => FindGroups(sl()));
  sl.registerLazySingleton(() => FindTeachers(sl()));
  sl.registerLazySingleton(() => GetAllBuildings(sl()));
  sl.registerLazySingleton(() => GetRoomsOfBuilding(sl()));
  sl.registerLazySingleton(() => OnAppStart(sl()));

  sl.registerLazySingleton(() => GetFeaturedGroups(sl()));
  sl.registerLazySingleton(() => SetFeaturedGroups(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedGroup(sl(), sl()));
  sl.registerLazySingleton(() => GetFeaturedTeachers(sl()));
  sl.registerLazySingleton(() => SetFeaturedTeachers(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedTeacher(sl(), sl()));
  sl.registerLazySingleton(() => GetFeaturedRooms(sl()));
  sl.registerLazySingleton(() => SetFeaturedRooms(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedRoom(sl(), sl()));

  sl.registerLazySingleton(() => isSavedInFeatured(sl()));

  sl.registerLazySingleton(() => SaveLastSchedule(sl()));
  sl.registerLazySingleton(() => GetLastSchedule(sl()));

  //Featured Repository
  sl.registerSingleton<FeaturedRepository>(
    FeaturedRepositorySourceImpl(
      featuredGroups: Hive.box<Group>('featured_groups'),
      featuredTeachers: Hive.box<Teacher>('featured_teachers'),
      featuredRooms: Hive.box<Room>('featured_rooms'),
      logger: sl(),
    ),
  );

  // Data Sources
  sl.registerSingleton(
    RemoteScheduleDataSourceImpl(client: sl(), logger: sl()),
  );
  sl.registerSingleton<FetchRemoteDataSourceImpl>(
    FetchRemoteDataSourceImpl(client: sl(), logger: sl()),
  );

  sl.registerSingleton<HiveCache<Week, ScheduleKey>>(
    HiveCache<Week, ScheduleKey>(
      box: Hive.box<(Week, DateTime)>('schedule_cache'),
      entriesCount: 30,
      logger: sl(),
    ),
  );

  sl.registerSingleton(
    CacheDataSource(
      prevDataSource: sl<RemoteScheduleDataSourceImpl>(),
      localBox: sl(),
      logger: sl(),
    ),
  );

  sl.registerSingleton(
    LocalDataSource(
      prevDataSource: sl<CacheDataSource>(),
      localBox: Hive.box<Week>('schedule_local'),
      featuredRepository: sl<FeaturedRepository>(),
      logger: sl(),
    ),
  );
  sl.registerSingleton(
    PrefetchDataSource(prevDataSource: sl<LocalDataSource>(), prefetchSize: 2),
  );

  // Repositories
  sl.registerSingleton<ScheduleRepository>(
    ScheduleRepositoryImpl(scheduleDataSource: sl<PrefetchDataSource>()),
  );
  // Repositories
  sl.registerSingleton<FetchRepository>(
    FetchRepositoryImpl(fetchDataSource: sl<FetchRemoteDataSourceImpl>()),
  );

  sl.registerSingleton<LastScheduleRepository>(
    LastScheduleRepositoryImpl(
      Hive.box<LastSchedule>('last_schedule'),
      logger: sl(),
    ),
  );

  // BLoC
  sl.registerFactory<BuildingSearchBloc>(
    () => BuildingSearchBloc(getAllBuildings: sl()),
  );
  sl.registerFactory<ClassSearchBloc>(
    () => ClassSearchBloc(getRoomsOfBuilding: sl(), addFeaturedRoom: sl()),
  );
  sl.registerFactory<FeaturedBloc>(
    () => FeaturedBloc(
      getFeaturedGroups: sl(),
      getFeaturedTeachers: sl(),
      getFeaturedRooms: sl(),
      setFeaturedGroups: sl(),
      setFeaturedTeachers: sl(),
      setFeaturedRooms: sl(),
    ),
  );
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      findGroups: sl(),
      findTeachers: sl(),
      addFeaturedGroup: sl(),
      addFeaturedTeacher: sl(),
    ),
  );
  sl.registerFactory<ScheduleBloc>(
    () => ScheduleBloc(getSchedule: sl<GetSchedule>()),
  );

  // Services
  sl.registerSingleton<LastScheduleService>(
    LastScheduleService(saveLastSchedule: sl(), getLastSchedule: sl()),
  );
}
