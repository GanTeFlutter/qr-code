# Paket Listesi

> Projeye eklenecek ve mevcut paketlerin tam listesi.

---

## Eklenecek Paketler

| Paket | Versiyon | Amac | Faz |
|---|---|---|---|
| `qr` | 3.0.2 | QR matris verisi uretimi (Reed-Solomon, encoding) | F2 |
| `mobile_scanner` | latest | Kamera ile QR/barkod tarama, flas, kamera gecisi | F1 |
| `image_picker` | latest | Galeriden resim secme (QR taratma + logo secimi) | F1, F4 |
| `image_cropper` | 8.0.2 | Resim kirpma (QR bolgesini kirpma + logo kirpma) | F1, F4 |
| `gal` | latest | Olusturulan QR'i galeriye kaydetme | F2 |
| `share_plus` | latest | QR'i diger uygulamalarla paylasma | F2 |
| `permission_handler` | latest | Kamera/galeri izinleri yonetimi | F1 |

## Mevcut Paketler (Zaten Projede)

| Paket | Ne Icin Kullanilacak |
|---|---|
| `url_launcher` | URL ac, telefon ara, e-posta ac, haritada goster, SMS |
| `audioplayers` | Tarama sesi efekti |
| `hive_ce` | Gecmis/favoriler yerel DB |
| `path_provider` | Dosya yolu erisimi |
| `shared_preferences` | Ayarlar cache |
| `flutter_bloc` | State management (Cubit) |
| `go_router` | Navigation |
| `easy_localization` | TR/EN dil destegi |
| `firebase_remote_config` | Versiyon kontrolu |
| `package_info_plus` | Uygulama versiyon bilgisi |

## Built-in (Paket Gerektirmeyen)

| Arac | Ne Icin |
|---|---|
| `dart:ui` / `RenderRepaintBoundary` | QR widget'ini PNG'ye cevirme |
| `HapticFeedback` | Titresim geri bildirimi |
| `Clipboard` | QR icerik kopyalama |

## Sonraki Fazlarda Gerekebilecek

| Paket | Amac | Faz |
|---|---|---|
| `flutter_contacts` | vCard → rehbere ekleme | F1.2 |
| `wifi_iot` | Wi-Fi otomatik baglanma | F1.2 |
| `google_mobile_ads` | AdMob reklam entegrasyonu | F7 |
| `in_app_purchase` | Premium satin alma | F7 |

---

## Notlar

- `qr_flutter` kullanilmiyor — QR rendering icin kendi CustomPainter'imizi yaziyoruz (daha fazla ozellestirme kontrolu)
- `image_gallery_saver` yerine `gal` tercih edildi (modern, 5 platform destegi)
- `permission_handler` opsiyonel — `mobile_scanner` kendi izin yonetimini yapiyor ama diger izinler icin gerekli
