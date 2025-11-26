import 'dart:ui';

import 'package:hive/hive.dart';
import '../../domain/entities/theme_setting.dart';

class ThemeSettingAdapter extends TypeAdapter<ThemeSetting> {
  @override
  final typeId = 90;
  @override
  ThemeSetting read(BinaryReader reader) {
    var color = reader.read();
    var light = reader.readBool();
    return ThemeSetting(color: color, isLightTheme: light);
  }

  @override
  void write(BinaryWriter writer, ThemeSetting obj) {
    writer.write(obj.color);
    writer.writeBool(obj.isLightTheme);
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 91;
  @override
  Color read(BinaryReader reader) {
    var alpha = reader.readDouble();
    var red = reader.readDouble();
    var green = reader.readDouble();
    var blue = reader.readDouble();
    return Color.from(alpha: alpha, red: red, green: green, blue: blue);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeDouble(obj.a);
    writer.writeDouble(obj.r);
    writer.writeDouble(obj.g);
    writer.writeDouble(obj.b);
  }
}
