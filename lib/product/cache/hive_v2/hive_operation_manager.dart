import 'package:hive_ce/hive.dart';
import 'package:qrcode_akillisletme/product/cache/cache_manager.dart';

/// Hive cache operation manager.
/// Box'lar ProductCache.init() sirasinda onceden acilir,
/// bu nedenle constructor senkron erisim yapar.
final class HiveOperationManager<T extends CacheModel>
    extends CacheOperation<T> {
  HiveOperationManager() : _box = Hive.box(T.toString());

  final Box<T> _box;

  @override
  void add(T data) {
    _box.put(data.id, data);
  }

  @override
  void delete(T data) {
    _box.delete(data.id);
  }

  @override
  T? get(String id) {
    final value = _box.get(id);
    return value is T ? value : null;
  }

  @override
  List<T> getAll() {
    return _box.values.whereType<T>().toList();
  }

  @override
  void update(T data) {
    _box.put(data.id, data);
  }

  @override
  Future<bool> removeAll() async {
    await _box.clear();
    final itemList = getAll();
    return itemList.isEmpty;
  }
}
