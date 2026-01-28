import 'package:flutter/material.dart';
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

    sl<OnAppStart>()()
        .catchError((Object exception) {
          //TODO - error that schedule failed to be loaded
        })
        .then((_) {
          //TODO - message that schedule updated
        });

    Bloc.observer = BlocLogger(sl<AppLogger>());
    WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement FlutterError.onError
    // TODO: implement PlatformDispatcher.instance.onError
  }
}
