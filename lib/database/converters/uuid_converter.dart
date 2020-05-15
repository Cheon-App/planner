import 'package:moor/moor.dart';
import 'package:uuid/uuid.dart';

class UUIDConverter extends TypeConverter<String, Uint8List> {
  /// Converts [Uuid] objects to and from [Uint8List]s so they can be stored
  /// as a list of bytes instead of a string to improve efficiency.
  const UUIDConverter();

  @override
  String mapToDart(Uint8List fromDb) => uint8ListToUUID(fromDb);

  @override
  Uint8List mapToSql(String value) => uuidToUint8List(value);
}

Uint8List uuidToUint8List(String uuid) =>
    uuid != null ? Uint8List.fromList(Uuid().parse(uuid)) : null;

String uint8ListToUUID(Uint8List uint8list) =>
    uint8list != null ? Uuid().unparse(uint8list) : null;
