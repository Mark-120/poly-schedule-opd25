import 'app_exception.dart';

class RemoteException extends AppException {
  const RemoteException(super.message);

  @override
  ExceptionType get type => ExceptionType.remote;

  @override
  List<Object> get props => [message];
}
