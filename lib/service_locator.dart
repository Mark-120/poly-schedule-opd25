import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'core/logger.dart';
import 'core/presentation/theme_controller.dart';
import 'core/services/last_featured_service.dart';
import 'data/adapters/date.dart';
import 'data/adapters/featured.dart';
import 'data/adapters/ordered.dart';
import 'data/adapters/schedule/day.dart';
import 'data/adapters/schedule/lesson.dart';
import 'data/adapters/schedule/week.dart';
import 'data/adapters/scheduleEntities/building.dart';
import 'data/adapters/scheduleEntities/entity_id.dart';
import 'data/adapters/scheduleEntities/group.dart';
import 'data/adapters/scheduleEntities/room.dart';
import 'data/adapters/scheduleEntities/teacher.dart';
import 'data/adapters/theme.dart';
import 'data/data_sources/intermediate/prefetch.dart';
import 'data/data_sources/local/cache.dart';
import 'data/data_sources/local/hive_cache.dart';
import 'data/data_sources/local/local.dart';
import 'data/data_sources/local/schedule_key.dart';
import 'data/data_sources/remote/fetch_impl.dart';
import 'data/data_sources/remote/schedule_impl.dart';
import 'data/models/ordered/ordered.dart';
import 'data/repository/featured_repository.dart';
import 'data/repository/fetch_repository.dart';
import 'data/repository/last_featured_repository.dart';
import 'data/repository/schedule_repository.dart';
import 'data/repository/settings_repository.dart';
import 'domain/entities/featured.dart';
import 'domain/entities/schedule/week.dart';
import 'domain/repositories/featured_repository.dart';
import 'domain/repositories/fetch_repository.dart';
import 'domain/repositories/last_featured_repository.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/featured_usecases/delete_featured.dart';
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
import 'domain/usecases/last_featured_usecases/save_last_featured.dart';
import 'domain/usecases/schedule_usecases/find_groups.dart';
import 'domain/usecases/schedule_usecases/find_teachers.dart';
import 'domain/usecases/schedule_usecases/get_all_buildings.dart';
import 'domain/usecases/schedule_usecases/get_rooms_of_building.dart';
import 'domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import 'domain/usecases/schedule_usecases/on_app_start.dart';
import 'domain/usecases/schedule_usecases/refresh_schedule.dart';
import 'domain/usecases/settings_usecases/theme_setting.dart';
import 'domain/usecases/settings_usecases/update_constraints.dart';
import 'presentation/state_managers/building_search_screen_bloc/building_search_bloc.dart';
import 'presentation/state_managers/class_search_screen_bloc/class_search_bloc.dart';
import 'presentation/state_managers/featured_screen_bloc/featured_bloc.dart';
import 'presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
import 'presentation/state_managers/search_screen_bloc/search_bloc.dart';
import 'presentation_2.0/state_managers/schedule_bloc/schedule_bloc.dart';
import 'presentation_2.0/state_managers/search_screen_bloc/search_bloc.dart';
import 'presentation_2.0/state_managers/settings_bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<AppLogger>(
    () => kDebugMode ? DevLogger() : ProdLogger(),
  );

  // Hive
  await Hive.initFlutter();

  Hive.registerAdapter(DateAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(RoomIdAdapter());

  Hive.registerAdapter(TeacherIdAdapter());
  Hive.registerAdapter(GroupIdAdapter());
  Hive.registerAdapter(BuildingAdapter());

  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(WeekAdapter());
  Hive.registerAdapter(WeekDateAdapter());
  Hive.registerAdapter(FeaturedAdapter());

  Hive.registerAdapter(OrderedGroupAdapter());
  Hive.registerAdapter(OrderedRoomAdapter());
  Hive.registerAdapter(OrderedTeacherAdapter());

  Hive.registerAdapter(ThemeSettingAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox('settings');

  await Hive.openBox<Featured>('last_featured');

  await Hive.openBox<Week>('schedule_local');
  await Hive.openBox<(Week, DateTime)>('schedule_cache');

  await Hive.openBox<int>('featured_id');
  await Hive.openBox<OrderedGroup>('featured_groups');
  await Hive.openBox<OrderedTeacher>('featured_teachers');
  await Hive.openBox<OrderedRoom>('featured_rooms');

  // UseCases
  sl.registerLazySingleton(() => GetSchedule(sl()));
  sl.registerLazySingleton(() => OnAppStart(sl()));

  sl.registerLazySingleton(() => FindGroups(sl()));
  sl.registerLazySingleton(() => FindTeachers(sl()));
  sl.registerLazySingleton(() => GetBuildings(sl()));
  sl.registerLazySingleton(() => RefreshSchedule(sl()));
  sl.registerLazySingleton(() => GetRoomsOfBuilding(sl()));

  sl.registerLazySingleton(() => GetFeaturedGroups(sl()));
  sl.registerLazySingleton(() => SetFeaturedGroups(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedGroup(sl(), sl()));
  sl.registerLazySingleton(() => GetFeaturedTeachers(sl()));
  sl.registerLazySingleton(() => SetFeaturedTeachers(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedTeacher(sl(), sl()));
  sl.registerLazySingleton(() => GetFeaturedRooms(sl()));
  sl.registerLazySingleton(() => SetFeaturedRooms(sl(), sl()));
  sl.registerLazySingleton(() => AddFeaturedRoom(sl(), sl()));

  sl.registerLazySingleton(() => IsSavedInFeatured(sl()));
  sl.registerLazySingleton(() => DeleteFeatured(sl()));

  sl.registerLazySingleton(() => SaveLastFeatured(sl()));
  sl.registerLazySingleton(() => GetLastFeatured(sl()));

  sl.registerLazySingleton(() => UpdateKeepingConstraints(sl(), sl()));
  sl.registerLazySingleton(() => UpdateLoadingConstraints(sl(), sl()));
  sl.registerLazySingleton(() => UpdateThemeSettingsConstraints(sl()));
  sl.registerLazySingleton(() => GetKeepingConstraints(sl()));
  sl.registerLazySingleton(() => GetLoadingConstraints(sl()));
  sl.registerLazySingleton(() => GetThemeSettingsConstraints(sl()));

  //Featured Repository
  sl.registerSingleton<FeaturedRepository>(
    FeaturedRepositorySourceImpl(
      indexBox: Hive.box<int>('featured_id'),
      featuredGroups: Hive.box<OrderedGroup>('featured_groups'),
      featuredTeachers: Hive.box<OrderedTeacher>('featured_teachers'),
      featuredRooms: Hive.box<OrderedRoom>('featured_rooms'),
      logger: sl(),
    ),
  );

  // Data Sources
  sl.registerSingleton<SettingsRepository>(
    SettingsRepositoryImpl(settings: Hive.box('settings')),
  );

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
      settingsRepository: sl<SettingsRepository>(),
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
    FetchRepositoryImpl(
      fetchDataSource: sl<FetchRemoteDataSourceImpl>(),
      featuredRepository: sl<FeaturedRepository>(),
    ),
  );

  sl.registerSingleton<LastFeaturedRepository>(
    LastFeaturedRepositoryImpl(
      Hive.box<Featured>('last_featured'),
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
  sl.registerFactory<NewSearchBloc>(
    () => NewSearchBloc(
      findGroups: sl(),
      findTeachers: sl(),
      addFeaturedGroup: sl(),
      addFeaturedTeacher: sl(),
      findBuildings: sl(),
      getRoomsOfBuilding: sl(),
      addFeaturedRoom: sl(),
    ),
  );
  sl.registerFactory<ScheduleBloc>(
    () => ScheduleBloc(getSchedule: sl<GetSchedule>()),
  );
  sl.registerFactory<NewScheduleBloc>(
    () => NewScheduleBloc(
      getSchedule: sl<GetSchedule>(),
      addFeaturedGroup: sl(),
      addFeaturedTeacher: sl(),
      addFeaturedRoom: sl(),
      deleteFeatured: sl(),
      refreshSchedule: sl(),
    ),
  );

  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getLoading: sl(),
      getKeeping: sl(),
      getSavedTheme: sl(),
      updateLoading: sl(),
      updateKeeping: sl(),
      updateSavedTheme: sl(),
    ),
  );

  // Services
  sl.registerSingleton<LastFeaturedService>(
    LastFeaturedService(saveLastFeatured: sl(), getLastFeatured: sl()),
  );

  final loadTheme = sl<GetThemeSettingsConstraints>();
  final savedTheme = await loadTheme();

  // Регистрируем ThemeController как singleton
  sl.registerSingleton<AppThemeController>(AppThemeController(savedTheme));
}
