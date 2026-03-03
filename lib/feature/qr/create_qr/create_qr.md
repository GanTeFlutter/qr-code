# Create QR Module

## Summary
QR code creation feature with 3-screen flow: Type Selection → Form → Preview & Share.

## Structures
- CreateQrCubit: Manages type selection, form data, QR content generation, color/style/frame/logo customization, loadFromHistory (gecmisten veri yukleme)
- CreateQrState: selectedType, formData, qrContent, fgColor, bgColor, dotStyle, frameStyle, centerLogo, status
- QrType: Enum with 11 QR types (url, text, wifi, phone, sms, email, vcard, location, social, appStore, crypto)
- DotStyle: Enum (square, round, dot)
- FrameStyle: Enum (none, solid, rounded, dashed, shadow, elegant)
- QrContentParser: QR content string → Map<String, String> formData donusturucusu (11 tip icin parse metotlari)
- QrTypeCard: Type selection card widget (2-column grid)
- QrFormField: StatefulWidget, reusable form input widget (initialValue destekli, TextEditingController yonetimi)
- QrPreviewWidget: StatefulWidget with CustomPainter-based QR renderer, frame drawing, and center logo support
- Form widgets: UrlForm, TextQrForm, WifiForm, PhoneForm, SmsForm, EmailForm, VcardForm, LocationForm, SocialForm, AppStoreForm, CryptoForm — hepsi initialData (Map<String, String>?) destekler
- QrSvgExporter: SVG string generator from QR matrix data (no external SVG package)

## Customization
- Dot style: square, round, dot (SegmentedButton)
- Frame style: none, solid, rounded, dashed, shadow, elegant (horizontal scrollable cards)
- Center logo: Pick from gallery → square crop (image_picker + image_cropper) → rendered at QR center (~22%)
- Error correction: Level M (no logo) / Level H (with logo, %30 recovery)
- Foreground & background color presets

## Help Dialog
- AppBar info button (info_outline_rounded) on QrFormView, shared across all 11 form types
- Shows AlertDialog with QR type icon, "How It Works?" title, and type-specific description
- Localized strings: create_qr.help.title + create_qr.help.<type> (TR/EN)

## SVG Export
- QrSvgExporter generates SVG string from QR matrix (qr package) — no extra dependency
- DotStyle mapping: square → `<rect>`, round → `<rect rx>`, dot → `<circle>`
- Supports all FrameStyle values + center logo (base64 `<image>`)
- Android: Saves to `/Download/QR Codes/` with `.nomedia` (prevents gallery indexing)
- iOS: Saves to app documents directory (visible in Files app via UIFileSharingEnabled + LSSupportsOpeningDocumentsInPlace in Info.plist)

## Navigation
- CreateQrView pushed via go_router (CreateQrRoute)
- QrFormView and QrPreviewView pushed via Navigator.push with BlocProvider.value (shared cubit)
- CreateQrRoute `$extra: QrHistoryCacheModel?` destekler — gecmisten gelince tip secimi atlanir, form dolu acilir

## History → Create QR (Tap-to-Edit)
Gecmis ekranindan bir ogeye tiklandiginda kayitli verilerle dogrudan form acilir.

### Akis
```
HistoryListTile.onTap → CreateQrRoute($extra: item).push(context)
  → CreateQrCubit.loadFromHistory(content, qrTypeName)
    → QrContentParser.parse(content, qrTypeName) → formData map
  → QrFormView(type, initialData: formData) — formlar dolu gelir
  → Kullanici duzenler → QR olusturur
```

### QrContentParser Desteklenen Formatlar
| Tip | Girdi Formati | Parse Sonucu |
|-----|---------------|-------------|
| url | raw URL | `{url}` |
| text | raw text | `{text}` |
| wifi | `WIFI:T:enc;S:ssid;P:pass;H:hidden;;` | `{ssid, password, encryption, hidden}` |
| phone | `tel:phone` | `{phone}` |
| sms | `smsto:phone:msg` | `{phone, message}` |
| email | `mailto:email?subject=...&body=...` | `{email, subject, message}` |
| vcard | BEGIN:VCARD...END:VCARD | `{name, phone, email, company}` |
| location | `geo:lat,lng` | `{latitude, longitude}` |
| social | `https://instagram.com/user` | `{platform, username}` |
| appStore | raw URL | `{store_platform, store_url}` |
| crypto | `bitcoin:addr?amount=0.5` | `{coin, address, amount}` |
