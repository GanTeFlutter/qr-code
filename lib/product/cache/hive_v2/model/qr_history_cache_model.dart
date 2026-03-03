import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qrcode_akillisletme/product/cache/cache_manager.dart';

part 'qr_history_cache_model.g.dart';

@JsonSerializable()
final class QrHistoryCacheModel with CacheModel, EquatableMixin {
  const QrHistoryCacheModel({
    this.historyId = '',
    this.content = '',
    this.qrTypeName = '',
    this.sourceName = '',
    this.title = '',
    this.createdAt = '',
  });

  factory QrHistoryCacheModel.fromJson(Map<String, dynamic> json) {
    return _$QrHistoryCacheModelFromJson(json);
  }

  final String historyId;
  final String content;
  final String qrTypeName;
  final String sourceName;
  final String title;
  final String createdAt;

  @override
  String get id => historyId;

  @override
  List<Object?> get props => [
        historyId,
        content,
        qrTypeName,
        sourceName,
        title,
        createdAt,
      ];

  @override
  QrHistoryCacheModel fromDynamicJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw Exception('Invalid json type');
    return QrHistoryCacheModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$QrHistoryCacheModelToJson(this);

  QrHistoryCacheModel copyWith({
    String? historyId,
    String? content,
    String? qrTypeName,
    String? sourceName,
    String? title,
    String? createdAt,
  }) {
    return QrHistoryCacheModel(
      historyId: historyId ?? this.historyId,
      content: content ?? this.content,
      qrTypeName: qrTypeName ?? this.qrTypeName,
      sourceName: sourceName ?? this.sourceName,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
