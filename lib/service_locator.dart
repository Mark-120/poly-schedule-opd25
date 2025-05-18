import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import 'data/adapters/last_schedule.dart';
import 'data/models/last_schedule.dart';
import 'data/repository/featured_repository.dart';
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
import 'data/repository/last_schedule_repository.dart';
import 'data/repository/schedule_repository.dart';
import 'domain/repositories/last_schedule_repository.dart';
import 'domain/usecases/last_schedule_usecases/save_last_schedule.dart';
import 'domain/usecases/schedule_usecases/get_all_buildings.dart';
import 'domain/repositories/featured_repository.dart';
import 'domain/entities/group.dart';
import 'domain/entities/teacher.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/usecases/featured_usecases/featured_rooms/add_featured_room.dart';
import 'domain/usecases/featured_usecases/featured_groups/add_featured_group.dart';
import 'domain/usecases/featured_usecases/featured_teachers/add_featured_teacher.dart';
import 'domain/usecases/featured_usecases/featured_groups/get_featured_groups.dart';
import 'domain/usecases/featured_usecases/featured_groups/set_featured_groups.dart';
import 'domain/usecases/featured_usecases/featured_rooms/get_featured_rooms.dart';
import 'domain/usecases/featured_usecases/featured_rooms/set_featured_rooms.dart';
import 'domain/usecases/featured_usecases/featured_teachers/get_featured_teachers.dart';
import 'domain/usecases/featured_usecases/featured_teachers/set_featured_teachers.dart';
import 'domain/usecases/schedule_usecases/find_groups.dart';
import 'domain/usecases/schedule_usecases/find_teachers.dart';
import 'domain/usecases/schedule_usecases/get_rooms_of_building.dart';
import 'domain/usecases/schedule_usecases/get_schedule_usecases.dart';
import 'presentation/state_managers/building_search_screen_bloc/building_search_bloc.dart';
import 'presentation/state_managers/class_search_screen_bloc/class_search_bloc.dart';
import 'presentation/state_managers/featured_screen_bloc/featured_bloc.dart';
import 'presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';

import 'domain/entities/room.dart';
import 'domain/entities/schedule/week.dart';
import 'presentation/state_managers/search_screen_bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //State managers
  sl.registerFactory(
    () => ScheduleBloc(
      getScheduleByGroup: sl<GetScheduleByGroup>(),
      getScheduleByTeacher: sl<GetScheduleByTeacher>(),
      getScheduleByRoom: sl<GetScheduleByRoom>(),
    ),
  );

  sl.registerFactory(
    () => FeaturedBloc(
      getFeaturedGroups: sl<GetFeaturedGroups>(),
      getFeaturedTeachers: sl<GetFeaturedTeachers>(),
      getFeaturedRooms: sl<GetFeaturedRooms>(),
      setFeaturedGroups: sl<SetFeaturedGroups>(),
      setFeaturedTeachers: sl<SetFeaturedTeachers>(),
      setFeaturedRooms: sl<SetFeaturedRooms>(),
      saveLastSchedule: sl<SaveLastSchedule>(),
    ),
  );

  sl.registerFactory(
    () => SearchBloc(
      findGroups: sl<FindGroups>(),
      findTeachers: sl<FindTeachers>(),
      addFeaturedGroup: sl<AddFeaturedGroup>(),
      addFeaturedTeacher: sl<AddFeaturedTeacher>(),
    ),
  );

  sl.registerFactory(
    () => ClassSearchBloc(
      getRoomsOfBuilding: sl<GetRoomsOfBuilding>(),
      addFeaturedRoom: sl<AddFeaturedRoom>(),
    ),
  );

  sl.registerFactory(
    () => BuildingSearchBloc(getAllBuildings: sl<GetAllBuildings>()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetScheduleByGroup(sl()));
  sl.registerLazySingleton(() => GetScheduleByTeacher(sl()));
  sl.registerLazySingleton(() => GetScheduleByRoom(sl()));
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
    () => ScheduleRepositoryImpl(prevDataSource: sl<CacheDataSource>()),
  );

  sl.registerLazySingleton<FeaturedRepository>(
    () => FeaturedRepositorySourceImpl(
      featuredGroups: Hive.box<Group>('featured_groups'),
      featuredTeachers: Hive.box<Teacher>('featured_teachers'),
      featuredRooms: Hive.box<Room>('featured_rooms'),
    ),
  );

  sl.registerLazySingleton<LastScheduleRepository>(
    () => LastScheduleRepositoryImpl(Hive.box<LastSchedule>('last_schedule')),
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
  Hive.registerAdapter(LastScheduleAdapter());

  await Hive.openBox<LastSchedule>('last_schedule');

  await Hive.openBox<(Week, DateTime)>('group_schedule_cache');
  await Hive.openBox<(Week, DateTime)>('room_schedule_cache');
  await Hive.openBox<(Week, DateTime)>('teacher_schedule_cache');

  await Hive.openBox<Group>('featured_groups');
  await Hive.openBox<Teacher>('featured_teachers');
  await Hive.openBox<Room>('featured_rooms');

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
