# QR Kod Akilli Isletme

Flutter ile gelistirilen, QR kod tarama ve olusturma uygulamasi.
11 farkli QR tipi destegi, gecmis yonetimi, coklu tema ve TR/EN dil destegi sunar.

---

## Uygulama Akisi

```
Splash (Firebase Remote Config ile versiyon kontrolu)
  |
  v
Onboarding (5 adim, ilk acilista bir kez gosterilir)
  |
  v
Home (Ana menu — 4 bolum)
  |--- QR Tara (Kamera / Galeri)
  |--- QR Olustur (11 tip, form dogrulama, stil ozellestirme)
  |--- Gecmis (Hive ile kalici depolama, filtreleme, arama)
  |--- Ayarlar (Tema, Dil, Animasyon)
```

---

## Ozellikler

### QR Tarama
- Kamera ile canli tarama (`mobile_scanner`)
- Galeriden resim secip tarama
- Flas acma/kapama, on/arka kamera gecisi
- 11 icerik tipi otomatik tanima (URL, E-posta, Telefon, WiFi, vCard, Konum, Kripto vb.)
- Tarama sonucu bottom sheet ile gosterim
- Haptic feedback + ses efekti

### QR Olusturma
- **Desteklenen 11 tip:** URL, Metin, WiFi, Telefon, SMS, E-posta, vCard, Konum, Sosyal Medya, App Store, Kripto
- Her tip icin ozel form alanlari ve dogrulama
- Stil ozellestirme (renk, nokta stili, cerceve)
- Logo/gorsel ekleme destegi
- Gecmisten yukleyerek yeniden duzenleme

### Gecmis
- Taranan ve olusturulan QR'lerin Hive ile kalici saklanmasi
- Kaynak bazli filtreleme (Tumu / Olusturulan / Taranan)
- Icerik ve baslik ile arama
- Tekil silme veya tumunu temizleme

### Ayarlar
- 5 renk varyanti (Mor, Mavi, Yesil, Turuncu, Kirmizi)
- 3 tema modu (Acik, Koyu, Sistem)
- Dil secimi (Turkce, Ingilizce)
- Arka plan animasyonu acma/kapama

---

## Mimari

### Klasor Yapisi

```
lib/
├── main.dart
├── feature/                          # Ozellik modulleri
│   ├── login_process/
│   │   ├── splash/                   # Versiyon kontrolu
│   │   └── onboarding/              # 5 adimli tanitim
│   ├── home/                         # Ana menu
│   ├── qr/
│   │   ├── scanner/                  # QR tarama
│   │   ├── create_qr/               # QR olusturma (11 tip)
│   │   └── history/                  # Gecmis yonetimi
│   └── settings/                     # Ayarlar
└── product/                          # Proje geneli altyapi
    ├── cache/                        # Hive + SharedPreferences
    ├── const/                        # Sabitler (AppString)
    ├── enum/                         # Enumlar
    ├── init/                         # Baslangic & dil ayarlari
    ├── navigation/                   # go_router + TypedGoRoute
    ├── service/                      # GetIt + RemoteConfigService
    ├── state/                        # Global state
    ├── theme/                        # Material 3 tema sistemi
    ├── utils/                        # Responsive, validator, feedback
    └── widget/                       # Paylasilir butonlar
```

### Her Feature Icindeki Alt Klasorler

```
feature/<feature>/
├── state/       # Cubit + Freezed state
├── widget/      # Feature'a ozel widget'lar
├── model/       # Veri modelleri
├── service/     # Feature'a ozel servisler
└── view/        # Ekran dosyalari
```

---

## Teknoloji Yigini

| Katman | Teknoloji |
|---|---|
| State Management | `flutter_bloc` (Cubit) + `freezed` |
| Routing | `go_router` + `TypedGoRoute` (code generation) |
| DI / Service Locator | `get_it` |
| Kalici Veri | `hive_ce` (model/liste) + `s
hared_preferences` (anahtar-deger) |
| Lokalizasyon | `easy_localization` (TR / EN) |
| Tema | Material 3, `ColorScheme.fromSeed()`, 5 renk varyanti |
| Firebase | `firebase_remote_config` (versiyon kontrolu) |
| QR Tarama | `mobile_scanner` |
| QR Uretim | `qr` (Reed-Solomon matris) |
| Medya | `image_picker`, `image_cropper`, `gal`, `share_plus` |
| Font | Poppins + Inter |

---

## Baslangic Pipeline'i

```
main()
  1. WidgetsFlutterBinding.ensureInitialized()
  2. EasyLocalization.ensureInitialized()
  3. Firebase.initializeApp()
  4. setupLocator()
     a. SharedCache.init()        — SharedPreferences
     b. ProductCache.init()       — Hive kutusu acma
     c. RemoteConfigService.init() — Firebase fetch
  5. StateInitialize              — Global BlocProvider'lar (ThemeCubit)
  6. AppBuilder                   — Animasyonlu arka plan katmani
  7. MaterialApp.router           — Tema, router, lokalizasyon
```

---

## State Yonetimi

### Global State
| Cubit | Konum | Amac |
|---|---|---|
| `ThemeCubit` | `product/theme/state/` | Tema varyanti + mod yonetimi, SharedPreferences ile kalici |

### Feature State
| Cubit | Konum | State Tipleri |
|---|---|---|
| `SplashCubit` | `login_process/splash/state/` | initial, checking, success, updateRequired, error |
| `OnboardingCubit` | `login_process/onboarding/cubit/` | int (sayfa indeksi) |
| `ScannerCubit` | `qr/scanner/state/` | ScannerState (Freezed) |
| `CreateQrCubit` | `qr/create_qr/state/` | CreateQrState (Freezed) |
| `HistoryCubit` | `qr/history/state/` | HistoryState (filter, search, liste) |

---

## Cache Sistemi

### SharedPreferences (SharedCache)
Basit anahtar-deger ciftleri:

| Anahtar | Tip | Aciklama |
|---|---|---|
| `firstAppOpen` | bool | Ilk acilis kontrolu |
| `theme` | int | Tema modu indeksi |
| `themeVariant` | String | Renk varyanti |
| `onboardingCompleted` | bool | Tanitim tamamlandi mi |
| `backgroundAnimation` | bool | Animasyon acik/kapali |

### Hive (ProductCache)
Yapisal veri depolama:

| Model | Alanlar | Amac |
|---|---|---|
| `AppCacheModel` | isHomeViewGrid, lastSearchItems | Uygulama tercihleri |
| `QrHistoryCacheModel` | historyId, content, qrTypeName, sourceName, title, createdAt | QR gecmisi |

---

## Routing

```dart
/splash                 → SplashRoute (giris noktasi)
/onboarding             → OnboardingRoute
/                       → HomeRoute (ana menu)
  /scanner              → ScannerRoute
  /create-qr            → CreateQrRoute
  /history              → HistoryRoute
  /settings             → SettingsRoute
```

- Splash & Onboarding: Fade gecis
- Diger sayfalar: Slide right gecis

---

## Desteklenen QR Tipleri

| # | Tip | Format Ornegi |
|---|---|---|
| 1 | URL | `https://example.com` |
| 2 | Metin | Serbest metin |
| 3 | WiFi | `WIFI:T:WPA;S:AgAdi;P:Sifre;;` |
| 4 | Telefon | `tel:+905551234567` |
| 5 | SMS | `smsto:+905551234567:Mesaj` |
| 6 | E-posta | `mailto:a@b.com?subject=...&body=...` |
| 7 | vCard | Kisi bilgileri (ad, telefon, e-posta, adres) |
| 8 | Konum | `geo:41.0082,28.9784` |
| 9 | Sosyal Medya | Profil linkleri |
| 10 | App Store | Magaza linkleri |
| 11 | Kripto | `bitcoin:adres`, `ethereum:adres` |

---

## Gelistirme

### Gereksinimler
- Flutter SDK >= 3.10.7
- Dart SDK (pubspec'te belirtilen)

### Kurulum
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Code Generation (Freezed, Hive, GoRouter)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Calistirma
```bash
flutter run
```

---

## Dokumanlar

| Dosya | Icerik |
|---|---|
| `doc/new_feature/README.md` | Yeni ozellik ekleme rehberi (indeks) |
| `doc/new_feature/folder_structure.md` | Klasor yapisi kurallari |
| `doc/new_feature/state_management.md` | Cubit + Freezed rehberi |
| `doc/new_feature/service_rules.md` | Servis yazim kurallari |
| `doc/new_feature/service_initialization.md` | Servis kayit rehberi |
| `doc/new_feature/model_rules.md` | Model yazim kurallari |
| `doc/new_feature/view_rules.md` | Ekran yazim kurallari |
| `doc/new_feature/widget_and_theme.md` | Widget ve tema kurallari |
| `doc/new_feature/data_storage.md` | Cache kullanim rehberi |
| `doc/new_feature/enums_and_constants.md` | Enum ve sabit kurallari |
| `doc/new_feature/route_and_strings.md` | Rota ve string ekleme |
| `doc/packages.md` | Paket listesi ve planlanan paketler |
| `lib/product/cache/CACHE_GUIDE.md` | Hive cache detayli rehber |
| `lib/product/theme/THEME.md` | Tema sistemi rehberi |
