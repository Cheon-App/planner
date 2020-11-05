abstract class KeyValueService {
  /// Writes a key value pair to local storage
  Future<void> setValue<T>(String key, T value);

  /// Retreives a key value pair from local storage
  T getValue<T>(String key);

  /// Returns a list containing all keys with corresponding values
  List<String> getKeys();

  /// Deletes all key value pairs
  Future<void> clearAll();

  /// Returns a stream for a value that updates whenever the key value pair is
  /// updated
  Stream<dynamic> valueStream(String key);
}
