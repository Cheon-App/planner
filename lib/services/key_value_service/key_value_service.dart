abstract class KeyValueService {
  /// Writes a key value pair to local storage
  Future<void> setValue(String key, dynamic value);

  /// Retreives a key value pair from local storage
  dynamic getValue(String key);

  /// Returns a list containing all keys with corresponding values
  List<String> getKeys();

  /// Deletes all key value pairs
  Future<void> clearAll();

  /// Returns a stream for a value that updates whenever the key value pair is
  /// updated
  Stream<dynamic> valueStream(String key);
}
