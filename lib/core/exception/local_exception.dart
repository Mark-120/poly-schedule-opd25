import 'package:equatable/equatable.dart';

class LocalException extends Equatable {
  final String message;
  const LocalException(this.message);
  @override
  List<Object> get props => [];
}
