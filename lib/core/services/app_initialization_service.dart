import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../domain/usecases/schedule_usecases/on_app_start.dart';
import '../../service_locator.dart' as di;
import '../../service_locator.dart';
import '../logger.dart';
import '../presentation/bloc_observer.dart';

class AppInitializationService {
  static Future<void> initializeApplication() async {
    await initializeDateFormatting('ru', null);
    await di.init();
    await sl<OnAppStart>()();
    Bloc.observer = BlocLogger(sl<AppLogger>());
  }
}
