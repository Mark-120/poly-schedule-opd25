import 'package:logger/logger.dart';

abstract class AppLogger {
  void debug(dynamic message, {StackTrace? stackTrace, Object? error});
  void info(dynamic message, {StackTrace? stackTrace, Object? error});
  void error(dynamic message, {StackTrace? stackTrace, Object? error});
}

class DevLogger extends AppLogger {
  final Logger _logger;

  DevLogger()
    : _logger = Logger(
        printer: PrettyPrinter(methodCount: 10, errorMethodCount: 10),
      );

  @override
  void debug(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.d(message, stackTrace: stackTrace, error: error);

  @override
  void error(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.e(message, stackTrace: stackTrace, error: error);

  @override
  void info(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.i(message, stackTrace: stackTrace, error: error);
}

class ProdLogger extends AppLogger {
  final Logger _logger;

  ProdLogger() : _logger = Logger(printer: SimplePrinter());

  @override
  void debug(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.d(message, stackTrace: stackTrace, error: error);

  @override
  void error(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.e(message, stackTrace: stackTrace, error: error);

  @override
  void info(message, {StackTrace? stackTrace, Object? error}) =>
      _logger.i(message, stackTrace: stackTrace, error: error);
}

class MockLogger extends AppLogger {
  @override
  void debug(message, {StackTrace? stackTrace, Object? error}) {}

  @override
  void error(message, {StackTrace? stackTrace, Object? error}) {}

  @override
  void info(message, {StackTrace? stackTrace, Object? error}) {}
}
