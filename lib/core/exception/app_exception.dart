import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable {
  final String message;
  ExceptionType get type;

  const AppException(this.message);
}

enum ExceptionType { local, remote, noConnection }
