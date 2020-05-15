import 'package:cheon/services/key_value_service/key_value_service.dart';
import 'package:hive/hive.dart';

class HiveKeyValueService implements KeyValueService {
  HiveKeyValueService(this.box);

  final Box<dynamic> box;

  @override
  List<String> getKeys() => box.keys.map((dynamic k) => k.toString()).toList();

  @override
  dynamic getValue(String key) => box.get(key);

  @override
  Future<void> setValue(String key, dynamic value) => box.put(key, value);

  @override
  Future<void> clearAll() => box.clear();

  @override
  Stream<dynamic> valueStream(String key) =>
      box.watch(key: key).map<dynamic>((BoxEvent b) => b.value);
}
