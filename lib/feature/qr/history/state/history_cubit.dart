import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/history/service/history_service.dart';
import 'package:qrcode_akillisletme/feature/qr/history/state/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required HistoryService historyService})
      : _service = historyService,
        super(const HistoryState());

  final HistoryService _service;

  /// Ilk sayfayi yukler.
  void loadHistory() {
    emit(state.copyWith(status: HistoryStatus.loading, currentPage: 0));
    try {
      final items = _service.getPage();
      final total = _service.totalCount;
      emit(
        state.copyWith(
          items: items,
          status: HistoryStatus.loaded,
          currentPage: 0,
          hasMore: items.length < total,
        ),
      );
    } on Exception catch (e) {
      log('HistoryCubit.loadHistory hatasi: $e');
      emit(
        state.copyWith(
          status: HistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Sonraki sayfayi yukler (sonsuz scroll icin).
  void loadMore() {
    if (!state.hasMore || state.status == HistoryStatus.loading) return;

    try {
      final nextPage = state.currentPage + 1;
      final newItems = _service.getPage(page: nextPage);
      if (newItems.isEmpty) {
        emit(state.copyWith(hasMore: false));
        return;
      }
      final total = _service.totalCount;
      final allItems = [...state.items, ...newItems];
      emit(
        state.copyWith(
          items: allItems,
          currentPage: nextPage,
          hasMore: allItems.length < total,
        ),
      );
    } on Exception catch (e) {
      log('HistoryCubit.loadMore hatasi: $e');
    }
  }

  void setFilter(HistoryFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void deleteItem(String historyId) {
    try {
      _service.delete(historyId);
      loadHistory();
    } on Exception catch (e) {
      log('HistoryCubit.deleteItem hatasi: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _service.clearAll();
      loadHistory();
    } on Exception catch (e) {
      log('HistoryCubit.clearAll hatasi: $e');
    }
  }
}
