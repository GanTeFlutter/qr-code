import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({
    required this.item,
    required this.onDelete,
    this.onTap,
    super.key,
  });

  final QrHistoryCacheModel item;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  QrType? get _qrType {
    final index = QrType.values.indexWhere((e) => e.name == item.qrTypeName);
    return index != -1 ? QrType.values[index] : null;
  }

  String get _formattedDate {
    final date = DateTime.tryParse(item.createdAt);
    if (date == null) return '';
    final d = date.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final type = _qrType;

    return Dismissible(
      key: ValueKey(item.historyId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.r(20)),
        margin: EdgeInsets.only(bottom: context.r(8)),
        decoration: BoxDecoration(
          color: cs.error,
          borderRadius: BorderRadius.circular(context.r(14)),
        ),
        child: Icon(
          Icons.delete_rounded,
          color: cs.onError,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: context.r(8)),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(context.r(14)),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.r(14),
              vertical: context.r(12),
            ),
            child: Row(
              children: [
                Container(
                  width: context.r(42),
                  height: context.r(42),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Icon(
                    type?.icon ?? Icons.qr_code_rounded,
                    color: cs.primary,
                    size: context.r(22),
                  ),
                ),
                SizedBox(width: context.r(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.isNotEmpty
                            ? item.title
                            : LocaleKeys.history_no_title.tr(),
                        style: TextStyle(
                          fontSize: context.rf(14),
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.r(2)),
                      Text(
                        item.content,
                        style: TextStyle(
                          fontSize: context.rf(12),
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.r(2)),
                      Text(
                        _formattedDate,
                        style: TextStyle(
                          fontSize: context.rf(10),
                          color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
