# QR Kod Akilli Isletme — Proje Dokumantasyonu

> Flutter ile gelistirilen, QR kod tarama ve olusturma uygulamasi.
> 11 farkli QR tipi destegi, gecmis yonetimi, coklu tema ve TR/EN dil destegi sunar.

---

## 1. Projenin Amaci

QR Kod Akilli Isletme, kullanicilarin:

- **QR kod taramasi** yapmasini (kamera veya galeriden)
- **11 farkli tipte QR kod olusturmasini** (URL, WiFi, vCard, Kripto vb.)
- Olusturdugu ve taradigi QR kodlari **gecmiste saklamasini**
- QR kodlarini **ozellestirmesini** (renk, stil, cerceve, logo)
- QR kodlarini **PNG/SVG olarak kaydetmesini ve paylasmasini**

saglayan bir mobil uygulamadir.

---

## 2. Ekranlar ve Islevsellikleri

### 2.1 Splash Ekrani
- Firebase Remote Config ile minimum versiyon kontrolu
- Guncelleme gerekiyorsa kullaniciyi bilgilendirme
- 5 saniyelik Firebase timeout (kotu ag icin koruma)

### 2.2 Onboarding (Tanitim)
- Ilk acilista bir kez gosterilir (SharedPreferences ile kontrol)
- 5 adimli sayfa gecisli tanitim
- Tamamlaninca tekrar gosterilmez (route guard)

### 2.3 Ana Sayfa (Home)
- 4 bolumlu menu: QR Tara, QR Olustur, Gecmis, Ayarlar
- Animasyonlu arka plan (kullanici tarafindan acilip kapatilabilir)

### 2.4 QR Tarama (Scanner)
- `mobile_scanner` ile canli kamera taramasi
- Galeriden resim secip QR tarama
- Flas acma/kapama, on/arka kamera gecisi
- 11 icerik tipi otomatik tanima
- Tarama sonucu bottom sheet ile gosterim
- Akilli aksiyon: URL ac, telefon ara, e-posta gonder, haritada goster
- Haptic feedback + sistem sesi
- URL scheme whitelist guvenlik kontrolu

### 2.5 QR Olusturma (Create QR)
- **11 desteklenen tip:**

| # | Tip | Format |
|---|---|---|
| 1 | URL | `https://example.com` |
| 2 | Metin | Serbest metin |
| 3 | WiFi | `WIFI:T:WPA;S:AgAdi;P:Sifre;;` |
| 4 | Telefon | `tel:+905551234567` |
| 5 | SMS | `smsto:+905551234567:Mesaj` |
| 6 | E-posta | `mailto:a@b.com?subject=...&body=...` |
| 7 | vCard | Kisi bilgileri (ad, telefon, e-posta, sirket) |
| 8 | Konum | `geo:41.0082,28.9784` |
| 9 | Sosyal Medya | Instagram, Twitter, Facebook, LinkedIn, TikTok, YouTube |
| 10 | App Store | Magaza linkleri |
| 11 | Kripto | `bitcoin:adres?amount=0.01` |

- Her tip icin ozel form alanlari ve anlık dogrulama
- QR Onizleme ekrani:
  - Renk ozellestirme (8 on plan + 4 arka plan renk)
  - 3 nokta stili (kare, yuvarlak, daire)
  - 6 cerceve stili (yok, duz, yuvarlak, kesikli, golge, elegant)
  - Logo/gorsel ekleme (kirpma + 2MB boyut limiti)
- Kaydetme: PNG (galeriye) + SVG (dosya sistemine)
- Paylasma: Sistem paylasim diyalogu
- Gecmisten yukleyerek yeniden duzenleme

### 2.6 Gecmis (History)
- Taranan ve olusturulan QR kodlarin Hive ile kalici saklanmasi
- Kaynak bazli filtreleme (Tumu / Olusturulan / Taranan)
- Icerik ve baslik ile arama
- Tekil silme veya tumunu temizleme
- Sayfalamali yukleme (50 kayit/sayfa, sonsuz scroll)
- Gecmisteki QR'i tiklayinca QR Olusturma ekraninda duzenleme

### 2.7 Ayarlar (Settings)
- 5 renk varyanti (Mor, Mavi, Yesil, Turuncu, Kirmizi)
- 3 tema modu (Acik, Koyu, Sistem)
- Dil secimi (Turkce, Ingilizce)
- Arka plan animasyonu acma/kapama

---

## 3. Mimari

### 3.1 Klasor Yapisi

```
lib/
├── main.dart                        # Giris noktasi + global error handler
├── feature/                         # Ozellik modulleri
│   ├── login_process/
│   │   ├── splash/                  # Versiyon kontrolu (Freezed state)
│   │   └── onboarding/             # 5 adimli tanitim
│   ├── home/                        # Ana menu + animasyonlu arka plan
│   ├── qr/
│   │   ├── scanner/                 # QR tarama (kamera + galeri)
│   │   │   ├── state/              # ScannerCubit + ScannerState
│   │   │   ├── service/            # SmartActionService (URL scheme guvenlik)
│   │   │   ├── model/              # ScanResultType (11 tip tanima)
│   │   │   └── widget/             # ScanResultSheet, ScannerOverlay
│   │   ├── create_qr/              # QR olusturma
│   │   │   ├── state/              # CreateQrCubit + CreateQrState
│   │   │   ├── service/            # QrSvgExporter, QrExportService, QrContentParser
│   │   │   ├── model/              # QrType enum
│   │   │   ├── view/               # CreateQrView, QrFormView, QrPreviewView
│   │   │   └── widget/             # QrPreviewWidget, QrCustomizeSheet, form alanlari
│   │   └── history/                 # Gecmis yonetimi
│   │       ├── state/              # HistoryCubit + HistoryState (pagination)
│   │       ├── service/            # HistoryService (sayfalamali)
│   │       └── widget/             # HistoryListTile, HistoryEmptyView
│   └── settings/                    # Ayarlar (tema, dil, animasyon)
└── product/                         # Proje geneli altyapi
    ├── cache/                       # Hive CE + SharedPreferences
    ├── const/                       # Sabitler
    ├── enum/                        # Enumlar (HistorySource)
    ├── init/                        # ApplicationInit, StateInitialize, AppLifecycleObserver
    ├── navigation/                  # GoRouter + TypedGoRoute (code-gen)
    ├── service/                     # GetIt service locator
    ├── theme/                       # Material 3 tema sistemi (5 varyant × 3 mod)
    ├── utils/                       # Responsive, FieldValidators, HapticHelper
    └── widget/                      # Paylasilir butonlar
```

### 3.2 Katmanli Mimari

```
View (Widget)
  ↓ context.read / BlocBuilder
Cubit (Is Mantigi)
  ↓ metot cagrisi
Service (Veri Erisimi)
  ↓
Cache / Network (Hive, Firebase)
```

---

## 4. Teknoloji Yigini

| Katman | Teknoloji | Versiyon |
|---|---|---|
| **UI Framework** | Flutter | SDK ^3.10.7 |
| **State Management** | `flutter_bloc` (Cubit) | 9.1.1 |
| **State Codegen** | `freezed` + `equatable` | 3.0.0 / 2.0.5 |
| **Routing** | `go_router` + `go_router_builder` | 17.1.0 / 4.2.0 |
| **DI** | `get_it` | 8.0.3 |
| **Kalici Veri** | `hive_ce` (model) + `shared_preferences` (key-value) | 2.11.3 / 2.5.4 |
| **Lokalizasyon** | `easy_localization` (TR / EN, 172 anahtar) | 3.0.1 |
| **Tema** | Material 3, `ColorScheme.fromSeed()` | - |
| **Firebase** | `firebase_core` + `firebase_remote_config` | 4.4.0 / 6.1.4 |
| **QR Tarama** | `mobile_scanner` (ML Kit) | 7.2.0 |
| **QR Uretim** | `qr` (Reed-Solomon matris) | 3.0.2 |
| **Medya** | `image_picker` + `image_cropper` + `gal` + `share_plus` | - |
| **URL Acma** | `url_launcher` | 6.3.1 |
| **Ses** | `audioplayers` | 6.5.1 |
| **Font** | Poppins (5 agirlik) + Inter (variable) | - |
| **Lint** | `very_good_analysis` | 7.0.0 |

---

## 5. Paket Listesi

### 5.1 Ana Bagimliliklar (dependencies)

| Paket | Versiyon | Amac |
|---|---|---|
| `flutter_bloc` | 9.1.1 | State management (Cubit pattern) |
| `freezed_annotation` | 3.0.0 | Freezed state anotasyonlari |
| `equatable` | 2.0.5 | State equality kontrolu |
| `go_router` | 17.1.0 | Deklaratif navigasyon |
| `get_it` | 8.0.3 | Dependency injection / service locator |
| `hive_ce` | 2.11.3 | Yapisal yerel veri depolama |
| `shared_preferences` | 2.5.4 | Basit anahtar-deger cache |
| `easy_localization` | 3.0.1 | Coklu dil destegi (TR/EN) |
| `firebase_core` | 4.4.0 | Firebase altyapisi |
| `firebase_remote_config` | 6.1.4 | Uzaktan yapilandirma (min versiyon) |
| `mobile_scanner` | 7.2.0 | Kamera ile QR/barkod tarama |
| `qr` | 3.0.2 | QR matris verisi uretimi |
| `image_picker` | 1.2.1 | Galeriden resim secme |
| `image_cropper` | 11.0.0 | Resim kirpma (logo icin) |
| `gal` | 2.3.2 | Galeriye resim kaydetme |
| `share_plus` | 12.0.1 | Sistem paylasim diyalogu |
| `url_launcher` | 6.3.1 | URL/tel/mailto/sms/geo acma |
| `permission_handler` | 12.0.1 | Cihaz izinleri yonetimi |
| `path_provider` | 2.1.5 | Dosya sistemi yol erisimi |
| `package_info_plus` | 8.3.0 | Uygulama versiyon bilgisi |
| `audioplayers` | 6.5.1 | Ses efektleri |
| `json_annotation` | 4.8.0 | JSON serializasyon anotasyonlari |
| `smooth_page_indicator` | 1.2.0+3 | Onboarding sayfa gostergesi |
| `cupertino_icons` | 1.0.8 | iOS stil ikonlar |

### 5.2 Gelistirme Bagimliliklari (dev_dependencies)

| Paket | Versiyon | Amac |
|---|---|---|
| `build_runner` | 2.4.15 | Code generation calistirici |
| `freezed` | 3.0.0 | State sinifi code-gen |
| `go_router_builder` | 4.2.0 | Typed route code-gen |
| `hive_ce_generator` | 1.10.0 | Hive adapter code-gen |
| `json_serializable` | 6.6.1 | JSON code-gen |
| `very_good_analysis` | 7.0.0 | Strict lint kurallari |
| `flutter_test` | SDK | Test framework |

### 5.3 Built-in (Paket Gerektirmeyen)

| Arac | Amac |
|---|---|
| `dart:ui` / `RenderRepaintBoundary` | QR widget'ini PNG'ye cevirme |
| `HapticFeedback` | Titresim geri bildirimi |
| `Clipboard` | Pano islemleri |
| `SystemSound` | Sistem sesleri |
| `dart:developer` `log()` | Debug loglama |

### 5.4 Sonraki Fazlarda Eklenebilecek

| Paket | Amac | Faz |
|---|---|---|
| `firebase_crashlytics` | Crash raporlama | F0.7 |
| `firebase_analytics` | Kullanim analizi | F0.7 |
| `flutter_contacts` | vCard → rehbere ekleme | F1.2 |
| `wifi_iot` | WiFi otomatik baglanma | F1.2 |
| `google_mobile_ads` | AdMob reklam entegrasyonu | F7 |
| `in_app_purchase` | Premium satin alma | F7 |

---

## 6. Calistirma

### 6.1 Gereksinimler
- Flutter SDK >= 3.10.7
- Android Studio (Android build icin)
- Xcode (iOS build icin)
- Firebase projesi (google-services.json + GoogleService-Info.plist)

### 6.2 Kurulum
```bash
# Bagimliliklari yukle
flutter pub get

# Code generation (Freezed, Hive, GoRouter)
dart run build_runner build --delete-conflicting-outputs
```

### 6.3 Calistirma
```bash
# Debug mod
flutter run

# Release mod (imzali)
flutter run --release
```

### 6.4 Build
```bash
# Android (App Bundle — Play Store icin)
flutter build appbundle --release --obfuscate \
  --split-debug-info=build/debug-info --tree-shake-icons

# iOS (IPA — App Store icin)
flutter build ipa --release --obfuscate \
  --split-debug-info=build/debug-info --tree-shake-icons
```

---

## 7. Baslangic Pipeline'i

```
main()
  ├── ApplicationInit.start()
  │   ├── WidgetsFlutterBinding.ensureInitialized()
  │   ├── EasyLocalization.ensureInitialized()
  │   ├── Firebase.initializeApp()          ← 5s timeout
  │   ├── setupLocator()
  │   │   ├── SharedCache.init()            ← SharedPreferences
  │   │   ├── ProductCache.init()           ← Hive kutulari
  │   │   ├── RemoteConfigService.init()    ← Firebase fetch (3s timeout)
  │   │   └── HistoryService (lazy)
  │   ├── HomeBackground ayari
  │   └── AppLifecycleObserver.init()       ← Yasam dongusu dinleyici
  │
  ├── FlutterError.onError                  ← Global Flutter hata yakalama
  ├── runZonedGuarded                       ← Yakalanmamis async hatalar
  │
  └── runApp()
      └── EasyLocalization
          └── StateInitialize (MultiBlocProvider)
              └── QrApp (MaterialApp.router)
                  └── AppBuilder (animasyonlu arka plan)
                      └── GoRouter → Sayfalar
```

---

## 8. State Yonetimi

### 8.1 Global State
| Cubit | Konum | Kalicilik |
|---|---|---|
| `ThemeCubit` | `product/theme/state/` | SharedPreferences |

### 8.2 Feature State
| Cubit | State Sinifi | Pattern | Ozellikler |
|---|---|---|---|
| `SplashCubit` | `SplashState` | Freezed union | initial, checking, success, updateRequired, error |
| `OnboardingCubit` | `int` | Primitif | Sayfa indeksi |
| `ScannerCubit` | `ScannerState` | Equatable + copyWith | idle/scanned, icerik, tip, duraklama |
| `CreateQrCubit` | `CreateQrState` | Equatable + copyWith | form, dogrulama, renkler, stiller, logo |
| `HistoryCubit` | `HistoryState` | Equatable + copyWith | liste, filtre, arama, sayfalama |

---

## 9. Cache Sistemi

### SharedPreferences (SharedCache)
| Anahtar | Tip | Aciklama |
|---|---|---|
| `firstAppOpen` | bool | Ilk acilis kontrolu |
| `theme` | int | Tema modu indeksi |
| `themeVariant` | String | Renk varyanti |
| `onboardingCompleted` | bool | Tanitim tamamlandi mi |
| `backgroundAnimation` | bool | Animasyon acik/kapali |

### Hive (ProductCache)
| Model | Alanlar | Amac |
|---|---|---|
| `QrHistoryCacheModel` | historyId, content, qrTypeName, sourceName, title, createdAt | QR gecmisi |
| `AppCacheModel` | isHomeViewGrid, lastSearchItems | Uygulama tercihleri |

---

## 10. Guvenlik Onlemleri

| Alan | Uygulama |
|---|---|
| URL Acma | `SmartActionService` — sadece izin verilen scheme'ler (http, https, tel, mailto, sms, geo) |
| Firebase | 5s init timeout, graceful fallback |
| Logo Yukleme | 2MB boyut limiti, kirpma zorunlu |
| Cache | Hive senkron erisim (race condition yok) |
| Hata Yakalama | Global FlutterError.onError + runZonedGuarded |
| Yasam Dongusu | AppLifecycleObserver — arka planda kaynaklari serbest birakir |

---

## 11. Routing

```
/splash              → SplashRoute     (FadeTransition)
/onboarding          → OnboardingRoute (FadeTransition) — route guard: tamamlandiysa /'e yonlendir
/                    → HomeRoute       (FadeTransition)
  /scanner           → ScannerRoute    (SlideRight)
  /create-qr         → CreateQrRoute   (SlideRight) — $extra ile gecmisten yukleme
  /history           → HistoryRoute    (SlideRight)
  /settings          → SettingsRoute   (SlideRight)
```

---

## 12. Notlar

- `qr_flutter` kullanilmiyor — QR rendering icin ozel `CustomPainter` (daha fazla ozellestirme kontrolu)
- `image_gallery_saver` yerine `gal` (modern, 5 platform destegi)
- `permission_handler` — `mobile_scanner` kendi izin yonetimini yapiyor ama diger izinler icin gerekli
- Tum state siniflarinda `Equatable` kullaniliyor — gereksiz rebuild onlenir
- History pagination: 50 kayit/sayfa, sonsuz scroll ile lazy loading
- QrPreviewView refactor edildi: ana view + QrCustomizeSheet + QrExportService olarak 3 dosyaya bolundu
