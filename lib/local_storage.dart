import 'package:localstorage/localstorage.dart';

class Storage {
  LocalStorage _storage;
  Storage(String store) {
    this._storage = new LocalStorage(store);
  }
  Future<bool> init() async {
    return await _storage.ready;
  }

  dynamic getItemFromStore(String key) {
    return _storage.getItem(key);
  }

  Future<void> addItemToStore(String key, dynamic value) async {
    return await _storage.setItem(key, value);
  }
}
