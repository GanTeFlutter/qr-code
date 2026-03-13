import 'package:equatable/equatable.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';

enum HistoryFilter { all, created, scanned }

enum HistoryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  const HistoryState({
    this.items = const [],
    this.filter = HistoryFilter.all,
    this.searchQuery = '',
    this.status = HistoryStatus.initial,
    this.errorMessage,
    this.currentPage = 0,
    this.hasMore = true,
  });

  final List<QrHistoryCacheModel> items;
  final HistoryFilter filter;
  final String searchQuery;
  final HistoryStatus status;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

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

  @override
  List<Object?> get props =>
      [items, filter, searchQuery, status, errorMessage, currentPage, hasMore];

  HistoryState copyWith({
    List<QrHistoryCacheModel>? items,
    HistoryFilter? filter,
    String? searchQuery,
    HistoryStatus? status,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return HistoryState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
