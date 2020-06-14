// Package imports:
import 'package:moor/moor.dart';

/// A Non-Nullable Value
class DbValue<T> implements Value<T> {
  DbValue(this.dbValue);
  final T dbValue;

  @override
  bool get present => dbValue != null;

  @override
  T get value => dbValue;
}
