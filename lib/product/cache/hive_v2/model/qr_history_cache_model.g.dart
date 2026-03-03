// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_history_cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrHistoryCacheModel _$QrHistoryCacheModelFromJson(Map<String, dynamic> json) =>
    QrHistoryCacheModel(
      historyId: json['historyId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      qrTypeName: json['qrTypeName'] as String? ?? '',
      sourceName: json['sourceName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$QrHistoryCacheModelToJson(
  QrHistoryCacheModel instance,
) => <String, dynamic>{
  'historyId': instance.historyId,
  'content': instance.content,
  'qrTypeName': instance.qrTypeName,
  'sourceName': instance.sourceName,
  'title': instance.title,
  'createdAt': instance.createdAt,
};
