import 'entity_id.dart';

class Entity {
  const Entity();
}

abstract class ScheduleEntity extends Entity {
  const ScheduleEntity();
  EntityId getId();
}
