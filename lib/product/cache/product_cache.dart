import 'package:hive_ce/hive.dart';
import 'package:qrcode_akillisletme/product/cache/cache_manager.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/hive_operation_manager.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/app_cache_model.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';

final class ProductCache {
  ProductCache({required CacheManager cacheManager})
    : _cacheManager = cacheManager;

  final CacheManager _cacheManager;

  Future<void> init() async {
    await _cacheManager.init([
      const AppCacheModel(),
      const QrHistoryCacheModel(),
    ]);

    // Box'lari onceden ac — HiveOperationManager senkron erisebilsin
    await Hive.openBox<AppCacheModel>('AppCacheModel');
    await Hive.openBox<QrHistoryCacheModel>('QrHistoryCacheModel');
  }

  late final CacheOperation<AppCacheModel> appModelCache =
      HiveOperationManager<AppCacheModel>();

  late final CacheOperation<QrHistoryCacheModel> historyCache =
      HiveOperationManager<QrHistoryCacheModel>();
}
