import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/history/state/history_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/history/state/history_state.dart';
import 'package:qrcode_akillisletme/feature/qr/history/widget/history_empty_view.dart';
import 'package:qrcode_akillisletme/feature/qr/history/widget/history_list_tile.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/navigation/app_router.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HistoryCubit(historyService: locator.historyService)..loadHistory(),
      child: const _HistoryBody(),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.history_title.tr()),
        actions: [
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: LocaleKeys.history_clear_all.tr(),
                onPressed: () => _showClearAllDialog(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama cubugu
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.r(16),
              vertical: context.r(8),
            ),
            child: TextField(
              onChanged: context.read<HistoryCubit>().setSearchQuery,
              decoration: InputDecoration(
                hintText: LocaleKeys.history_search.tr(),
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(14)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: context.r(10),
                ),
              ),
            ),
          ),

          // Filtre segmented button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.r(16)),
            child: BlocBuilder<HistoryCubit, HistoryState>(
              buildWhen: (p, c) => p.filter != c.filter,
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<HistoryFilter>(
                    segments: [
                      ButtonSegment(
                        value: HistoryFilter.all,
                        label: Text(LocaleKeys.history_filter_all.tr()),
                      ),
                      ButtonSegment(
                        value: HistoryFilter.created,
                        label: Text(LocaleKeys.history_filter_created.tr()),
                      ),
                      ButtonSegment(
                        value: HistoryFilter.scanned,
                        label: Text(LocaleKeys.history_filter_scanned.tr()),
                      ),
                    ],
                    selected: {state.filter},
                    onSelectionChanged: (v) =>
                        context.read<HistoryCubit>().setFilter(v.first),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: context.r(8)),

          // Liste veya bos durum
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state.status == HistoryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = state.filteredItems;
                if (items.isEmpty) {
                  return const HistoryEmptyView();
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      context.read<HistoryCubit>().loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.r(16),
                      vertical: context.r(4),
                    ),
                    itemExtent: 80,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return HistoryListTile(
                        item: item,
                        onDelete: () => context
                            .read<HistoryCubit>()
                            .deleteItem(item.historyId),
                        onTap: () =>
                            CreateQrRoute($extra: item).push<void>(context),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.history_clear_all.tr()),
        content: Text(LocaleKeys.history_clear_all_confirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(LocaleKeys.general_ok.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HistoryCubit>().clearAll();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(LocaleKeys.history_delete.tr()),
          ),
        ],
      ),
    );
  }
}
