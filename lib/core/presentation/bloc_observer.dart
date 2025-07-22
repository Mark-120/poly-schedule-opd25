import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../logger.dart';

class BlocLogger extends BlocObserver {
  final AppLogger logger;
  BlocLogger(this.logger);

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    final newState = change.nextState.toString();
    logger.debug(
      '[Bloc] ${bloc.toString()} - emit ${newState.substring(0, min(50, newState.length))}',
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug('[Bloc] ${bloc.toString()} - event ${event.toString()}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.error('[Bloc] ${bloc.toString()} - error ${error.toString()}');
  }
}
