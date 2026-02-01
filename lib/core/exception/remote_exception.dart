import 'package:equatable/equatable.dart';

class RemoteException extends Equatable {
  final String message;
  const RemoteException(this.message);
  @override
  List<Object> get props => [];
}
