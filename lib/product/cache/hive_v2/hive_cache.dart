import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrcode_akillisletme/product/cache/cache_manager.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/hive_registrar.g.dart';

final class HiveCacheManager extends CacheManager {
  HiveCacheManager({super.path});

  @override
  Future<void> init(List<CacheModel> cacheItems) async {
    final directoryPath =
        path ?? (await getApplicationDocumentsDirectory()).path;
    Hive.init(directoryPath);
    _register();
  }

  void _register() {
    Hive.registerAdapters();
  }

  @override
  void remove() {
    Hive.deleteFromDisk();
  }
}
