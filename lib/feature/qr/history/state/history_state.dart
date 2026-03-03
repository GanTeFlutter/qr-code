import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';

enum HistoryFilter { all, created, scanned }

enum HistoryStatus { initial, loading, loaded, error }

class HistoryState {
  const HistoryState({
    this.items = const [],
    this.filter = HistoryFilter.all,
    this.searchQuery = '',
    this.status = HistoryStatus.initial,
  });

  final List<QrHistoryCacheModel> items;
  final HistoryFilter filter;
  final String searchQuery;
  final HistoryStatus status;

  List<QrHistoryCacheModel> get filteredItems {
    var result = items;

    if (filter == HistoryFilter.created) {
      result = result
          .where((e) => e.sourceName == HistorySource.created.name)
          .toList();
    } else if (filter == HistoryFilter.scanned) {
      result = result
          .where((e) => e.sourceName == HistorySource.scanned.name)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.content.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  HistoryState copyWith({
    List<QrHistoryCacheModel>? items,
    HistoryFilter? filter,
    String? searchQuery,
    HistoryStatus? status,
  }) {
    return HistoryState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
    );
  }
}
