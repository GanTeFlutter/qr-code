import 'dart:math' show min;

import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/product/cache/cache_manager.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';

final class HistoryService {
  HistoryService()
      : _cache = locator.productCache.historyCache;

  final CacheOperation<QrHistoryCacheModel> _cache;

  /// Sayfa basi varsayilan kayit sayisi.
  static const defaultPageSize = 50;

  void addToHistory({
    required String content,
    required QrType qrType,
    required HistorySource source,
    required String title,
  }) {
    final model = QrHistoryCacheModel(
      historyId: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      qrTypeName: qrType.name,
      sourceName: source.name,
      title: title,
      createdAt: DateTime.now().toIso8601String(),
    );
    _cache.add(model);
  }

  /// Tum gecmis kayitlarini tarihe gore sirali doner.
  List<QrHistoryCacheModel> getAll() {
    final items = _cache.getAll()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  /// Sayfalanmis gecmis kayitlarini doner.
  List<QrHistoryCacheModel> getPage({
    int page = 0,
    int pageSize = defaultPageSize,
  }) {
    final all = getAll();
    final start = page * pageSize;
    if (start >= all.length) return [];
    return all.sublist(start, min(start + pageSize, all.length));
  }

  /// Toplam kayit sayisini doner.
  int get totalCount => _cache.getAll().length;

  List<QrHistoryCacheModel> getBySource(HistorySource source) {
    return getAll()
        .where((item) => item.sourceName == source.name)
        .toList();
  }

  void delete(String historyId) {
    final item = _cache.get(historyId);
    if (item == null) return;
    _cache.delete(item);
  }

  Future<bool> clearAll() => _cache.removeAll();
}
