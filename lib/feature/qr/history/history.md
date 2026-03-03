# History Modulu

## Amac
QR kod olusturma ve tarama gecmisini Hive CE uzerinde saklar. CRUD + filtreleme + arama destekler.

## Nasil Calisir

### Kayit Akisi
```
Kullanici "Kaydet" basar (qr_preview_view.dart)
  → _save()
    → state = context.read<CreateQrCubit>().state   (async gap ONCESI alinir)
    → await _exportPng() → await Gal.putImage()     (galeriye kayit)
    → HistoryService().addToHistory(...)             (gecmise kayit)
      → QrHistoryCacheModel olusturulur (historyId = timestamp)
      → _cache.add(model) → Hive box'a yazilir
    → SnackBar gosterilir
```

### Okuma Akisi
```
Kullanici Gecmis ekranini acar
  → BlocProvider → HistoryCubit()..loadHistory()
    → HistoryService().getAll()
      → Hive box'tan tum kayitlar okunur
      → Tarihe gore azalan siralama uygulanir
    → State'e items yazilir → UI guncellenir
```

### Filtreleme + Arama
- SegmentedButton: Tumu / Olusturulan / Taranan
- TextField: baslik ve icerik uzerinde case-insensitive arama
- Her ikisi de `HistoryState.filteredItems` getter'inda uygulanir (Cubit'e ek istek gitmez)

### Silme
- Tek oge: Dismissible ile sola kaydirma → `HistoryService.delete()` → Hive'dan sil → reload
- Tumunu temizle: AppBar ikonu → onay dialog → `HistoryService.clearAll()` → box temizle → reload

## Yapi
```
history/
  history_view.dart          — Ana ekran (BlocProvider + liste/bos durum)
  service/
    history_service.dart     — Hive CRUD islemleri
  state/
    history_cubit.dart       — Cubit (load, filter, search, delete, clear)
    history_state.dart       — State (items, filter, searchQuery, status)
  widget/
    history_list_tile.dart   — Gecmis ogesi karti (Dismissible ile silme, onTap ile QR olusturma formuna yonlendirme)
    history_empty_view.dart  — Bos durum widget'i
```

## Bagimliliklar

### Data Layer (product/)
| Dosya | Rol |
|-------|-----|
| `product/cache/hive_v2/model/qr_history_cache_model.dart` | Hive model (6 alan: historyId, content, qrTypeName, sourceName, title, createdAt) |
| `product/cache/hive_v2/hive_adapters.dart` | `AdapterSpec<QrHistoryCacheModel>()` → Hive adapter uretimi |
| `product/cache/hive_v2/hive_adapters.g.dart` | Generated: `QrHistoryCacheModelAdapter` (typeId=1, 6 field) |
| `product/cache/hive_v2/hive_registrar.g.dart` | Generated: adapter otomatik kayit |
| `product/cache/product_cache.dart` | `historyCache` field + `init()` icinde box onceden acilir |
| `product/enum/history_source.dart` | `HistorySource { created, scanned }` |

### Entegrasyon Noktalari
| Dosya | Baglanti |
|-------|----------|
| `create_qr/view/qr_preview_view.dart` | `_save()` icinde `HistoryService().addToHistory(...)` cagrilir |
| `product/service/service_locator.dart` | `locator.productCache.historyCache` uzerinden Hive erisimi |
| `product/navigation/app_router.dart` | `CreateQrRoute($extra: item)` ile gecmis → QR olusturma formu yonlendirmesi |

### Lokalizasyon
- `assets/translations/tr.json` → `history.*` (10 key)
- `assets/translations/en.json` → `history.*` (10 key)
- `lib/product/init/language/locale_keys.g.dart` → `history_*` generated key'ler

## Kritik: Hive Box Race Condition Cozumu

`HiveOperationManager` constructor'inda `_initializeBox()` async calisir (fire-and-forget).
Eger box onceden acik degilse `_box` null kalir ve yazma/okuma sessizce basarisiz olur.

**Cozum:** `ProductCache.init()` icinde box'lar `await Hive.openBox<T>(...)` ile onceden acilir.
Boylece `HiveOperationManager._initializeBox()` calistiginda `Hive.isBoxOpen()` true doner,
`await` atlanir ve `_box = Hive.box(...)` senkron olarak set edilir.

```dart
// product_cache.dart init() icinde:
await Hive.openBox<QrHistoryCacheModel>('QrHistoryCacheModel');
```

## Gecmisten QR Olusturma (Tap-to-Edit)

Gecmis listesindeki bir ogeye tiklandiginda, kayitli verilerle QR olusturma formuna gidilir.

### Akis
```
Kullanici gecmis ogesine tiklar (history_list_tile.dart onTap)
  → CreateQrRoute($extra: QrHistoryCacheModel).push<void>(context)
    → app_router.dart: CreateQrRoute.buildPage()
      → CreateQrCubit()..loadFromHistory(content, qrTypeName)
        → QrContentParser.parse(content, qrTypeName) → formData
      → QrFormView(type: selectedType, initialData: formData)
        → Form alanlari dolu gelir
  → Kullanici duzenler → QR olustur
```

## Ileride Eklenecek
- Scanner modulu ayni `HistoryService().addToHistory(source: HistorySource.scanned)` ile entegre edilir
