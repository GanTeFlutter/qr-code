// ignore_for_file: unused_element, document_ignores

import 'package:hive_ce/hive.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/app_cache_model.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';

@GenerateAdapters([
  AdapterSpec<AppCacheModel>(),
  AdapterSpec<QrHistoryCacheModel>(),
])
part 'hive_adapters.g.dart';
