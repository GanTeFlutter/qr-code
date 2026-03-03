import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/history/service/history_service.dart';
import 'package:qrcode_akillisletme/feature/qr/history/state/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  final _service = HistoryService();

  void loadHistory() {
    emit(state.copyWith(status: HistoryStatus.loading));
    final items = _service.getAll();
    emit(state.copyWith(items: items, status: HistoryStatus.loaded));
  }

  void setFilter(HistoryFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void deleteItem(String historyId) {
    _service.delete(historyId);
    loadHistory();
  }

  Future<void> clearAll() async {
    await _service.clearAll();
    loadHistory();
  }
}
