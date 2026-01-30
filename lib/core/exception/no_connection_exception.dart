import 'app_exception.dart';

class NoConnectionException extends AppException {
  const NoConnectionException(super.message);

  @override
  ExceptionType get type => ExceptionType.noConnection;

  @override
  List<Object> get props => [message];
}
