import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../domain/usecases/schedule_usecases/on_app_start.dart';
import '../../firebase_options.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
