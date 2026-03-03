// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AppCacheModelAdapter extends TypeAdapter<AppCacheModel> {
  @override
  final typeId = 0;

  @override
  AppCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppCacheModel(
      isHomeViewGrid: fields[0] == null ? false : fields[0] as bool,
      lastSearchItems: fields[1] == null
          ? const []
          : (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isHomeViewGrid)
      ..writeByte(1)
      ..write(obj.lastSearchItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QrHistoryCacheModelAdapter extends TypeAdapter<QrHistoryCacheModel> {
  @override
  final typeId = 1;

  @override
  QrHistoryCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrHistoryCacheModel(
      historyId: fields[0] == null ? '' : fields[0] as String,
      content: fields[1] == null ? '' : fields[1] as String,
      qrTypeName: fields[2] == null ? '' : fields[2] as String,
      sourceName: fields[3] == null ? '' : fields[3] as String,
      title: fields[4] == null ? '' : fields[4] as String,
      createdAt: fields[5] == null ? '' : fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QrHistoryCacheModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.historyId)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.qrTypeName)
      ..writeByte(3)
      ..write(obj.sourceName)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrHistoryCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
