import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    await dotenv.load();
    AppMetrica.activate(AppMetricaConfig(dotenv.get('APPMETRICS_API_KEY')));

    sl<OnAppStart>()()
        .catchError((Object exception) {
          //TODO - error that schedule failed to be loaded
        })
        .then((_) {
          //TODO - message that schedule updated
        });

    Bloc.observer = BlocLogger(sl<AppLogger>());
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (errorDetails) {
      AppMetrica.reportError(
        message: errorDetails.exception.toString(),
        errorDescription: AppMetricaErrorDescription(StackTrace.current),
      );
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      AppMetrica.reportError(
        message: error.toString(),
        errorDescription: AppMetricaErrorDescription(stack),
      );
      return true;
    };
  }
}
