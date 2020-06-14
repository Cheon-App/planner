// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:moor/moor.dart';

class ColorConverter extends TypeConverter<Color, int> {
  /// Converts [Color] objects to and from integers when storing them in the
  /// database
  const ColorConverter();
  @override
  Color mapToDart(int fromDb) => Color(fromDb);

  @override
  int mapToSql(Color value) => value.value;
}
