"buildings": [
  {
   "id": 78,
   "name": "ЛенЭнерго",
   "abbr": "ЛенЭнерго",
   "address": ""
  },

import 'package:equatable/equatable.dart';
import 'package:poly_scheduler/domain/entities/lesson.dart';

class Building extends Equatable {
  final int id;
  final String name;
  final String abbr;
  final String address;
  const Building({required this.id, required this.name, required this.abbr, required this.address});

  @override
  List<Object?> get props => [weekday, date, lessons];
}
