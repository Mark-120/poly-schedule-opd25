import 'app_exception.dart';

class LocalException extends AppException {
  const LocalException(super.message);

  @override
  ExceptionType get type => ExceptionType.local;

  @override
  List<Object> get props => [message];
}
