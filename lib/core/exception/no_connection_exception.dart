import 'package:equatable/equatable.dart';

class NoConnectionException extends Equatable {
  final String message;
  const NoConnectionException(this.message);
  @override
  List<Object> get props => [];
}
