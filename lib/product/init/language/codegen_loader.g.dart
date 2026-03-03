// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _tr = {
  "general": {
    "appName": "QR Kod Akıllı İşletme",
    "loading": "Yükleniyor...",
    "retry": "Tekrar Dene",
    "ok": "Tamam"
  },
  "error": {
    "title": "Bir Hata Oluştu"
  },
  "update": {
    "required": "Güncelleme Gerekli",
    "message": "Uygulamayı kullanmaya devam edebilmek için lütfen en son sürüme güncelleyin.",
    "button": "Güncelle"
  },
  "home": {
    "title": "Ana Sayfa",
    "scan": "QR Tara",
    "scanDesc": "Kamera ile QR/barkod tara",
    "create": "QR Oluştur",
    "createDesc": "Yeni QR kod oluştur",
    "history": "Geçmiş",
    "historyDesc": "Tarama ve oluşturma geçmişi",
    "settings": "Ayarlar",
    "settingsDesc": "Tema, dil ve diğer ayarlar"
  },
  "settings": {
    "appearance": "Görünüm",
    "language": "Dil",
    "backgroundAnimation": "Arka Plan Animasyonu"
  },
  "create_qr": {
    "title": "QR Oluştur",
    "subtitle": "Ne tür bir QR kod oluşturmak istiyorsun?",
    "search_hint": "QR türü ara...",
    "generate_button": "QR Kod Oluştur",
    "preview_title": "QR Önizleme",
    "customize": "Özelleştir",
    "dot_style": "Nokta Stili",
    "dot_square": "Kare",
    "dot_round": "Yuvarlak",
    "dot_circle": "Nokta",
    "qr_color": "QR Rengi",
    "bg_color": "Arka Plan",
    "frame_style": "Çerçeve Stili",
    "frame_none": "Yok",
    "frame_solid": "Düz",
    "frame_rounded": "Yuvarlak",
    "frame_dashed": "Kesikli",
    "frame_shadow": "Gölge",
    "frame_elegant": "Zarif",
    "logo": "Ortaya Logo",
    "add_logo": "Logo Ekle",
    "remove_logo": "Kaldır",
    "save": "Kaydet",
    "share": "Paylaş",
    "copied": "Kopyalandı",
    "saved_to_gallery": "Galeriye kaydedildi",
    "svg_saved": "SVG dosyası kaydedildi",
    "save_error": "Kaydedilemedi",
    "types": {
      "url": "URL",
      "url_desc": "Web sitesi linki",
      "text": "Metin",
      "text_desc": "Serbest metin",
      "wifi": "Wi-Fi",
      "wifi_desc": "Ağ bilgileri",
      "phone": "Telefon",
      "phone_desc": "Arama numarası",
      "sms": "SMS",
      "sms_desc": "Mesaj gönder",
      "email": "E-posta",
      "email_desc": "Mail adresi",
      "vcard": "Kişi Kartı",
      "vcard_desc": "Rehber bilgisi",
      "location": "Konum",
      "location_desc": "Harita koordinatı",
      "social": "Sosyal Medya",
      "social_desc": "Profil linki",
      "appStore": "Mağaza Linki",
      "appStore_desc": "Uygulama mağazası",
      "crypto": "Kripto Cüzdan",
      "crypto_desc": "Cüzdan adresi"
    },
    "help": {
      "title": "Nasıl Çalışır?",
      "url": "URL QR kodu tarandığında kullanıcıyı doğrudan bir web sitesine yönlendirir.\n\nTam URL'yi (https:// dahil) girin. Tarayan kişi QR kodu okuttuğunda tarayıcı otomatik açılır.",
      "text": "Metin QR kodu tarandığında serbest metin gösterir.\n\nNot, mesaj veya herhangi bir metin içeriği ekleyebilirsiniz. İnternet bağlantısı gerektirmez.",
      "wifi": "Wi-Fi QR kodu tarandığında cihazı otomatik olarak belirtilen ağa bağlar.\n\nAğ adı (SSID), şifre ve şifreleme türünü girin. Misafirlerinizin kolayca bağlanmasını sağlayın.",
      "phone": "Telefon QR kodu tarandığında belirtilen numarayı arama ekranına hazırlar.\n\nÜlke kodu dahil telefon numarasını girin. Tarayan kişi tek dokunuşla arayabilir.",
      "sms": "SMS QR kodu tarandığında belirtilen numaraya hazır bir mesaj oluşturur.\n\nTelefon numarası ve isteğe bağlı mesaj metni girin.",
      "email": "E-posta QR kodu tarandığında yeni bir e-posta taslağı açar.\n\nAlıcı adresi, konu ve mesaj içeriğini girin. Tarayan kişi doğrudan gönderebilir.",
      "vcard": "Kişi kartı QR kodu tarandığında kişi bilgilerini rehbere eklemeyi sağlar.\n\nİsim, telefon, e-posta ve şirket bilgilerini girin. Kartvizit yerine kullanılabilir.",
      "location": "Konum QR kodu tarandığında belirtilen koordinatları harita uygulamasında açar.\n\nEnlem ve boylam değerlerini girin. İşletme veya etkinlik konumunu paylaşmak için idealdir.",
      "social": "Sosyal medya QR kodu tarandığında belirtilen platforma yönlendirir.\n\nPlatform seçin ve kullanıcı adınızı girin. Takipçilerinizin sizi kolayca bulmasını sağlayın.",
      "appStore": "Mağaza linki QR kodu tarandığında uygulamanızın mağaza sayfasını açar.\n\nPlatform seçin ve mağaza URL'sini girin. Kullanıcılarınızın uygulamanızı indirmesini kolaylaştırın.",
      "crypto": "Kripto cüzdan QR kodu tarandığında ödeme bilgilerini aktarır.\n\nKripto para birimi seçin, cüzdan adresinizi ve isteğe bağlı miktar bilgisini girin."
    },
    "fields": {
      "url": "Website URL",
      "text": "Metin",
      "ssid": "Ağ Adı (SSID)",
      "password": "Şifre",
      "encryption": "Şifreleme",
      "hidden_network": "Gizli Ağ",
      "phone_number": "Telefon Numarası",
      "message": "Mesaj",
      "email_address": "E-posta Adresi",
      "subject": "Konu",
      "full_name": "Ad Soyad",
      "company": "Şirket",
      "latitude": "Enlem",
      "longitude": "Boylam",
      "platform": "Platform",
      "username": "Kullanıcı Adı",
      "username_hint": "ornek_kullanici",
      "store_platform": "Mağaza Platformu",
      "store_url": "Mağaza URL",
      "coin": "Kripto Para",
      "wallet_address": "Cüzdan Adresi",
      "wallet_hint": "Cüzdan adresini yapıştırın",
      "amount": "Miktar (İsteğe Bağlı)",
      "save_svg": "SVG Kaydet"
    }
  },
  "history": {
    "title": "Geçmiş",
    "search": "Geçmişte ara...",
    "filter_all": "Tümü",
    "filter_created": "Oluşturulan",
    "filter_scanned": "Taranan",
    "empty_title": "Henüz geçmiş yok",
    "empty_subtitle": "QR kod oluşturduğunuzda veya taradığınızda burada görünecek.",
    "clear_all": "Tümünü Temizle",
    "clear_all_confirm": "Tüm geçmiş silinecek. Bu işlem geri alınamaz.",
    "delete": "Sil",
    "no_title": "Başlıksız"
  }
};
static const Map<String,dynamic> _en = {
  "general": {
    "appName": "QR Code Smart Business",
    "loading": "Loading...",
    "retry": "Retry",
    "ok": "OK"
  },
  "error": {
    "title": "An Error Occurred"
  },
  "update": {
    "required": "Update Required",
    "message": "Please update to the latest version to continue using the app.",
    "button": "Update"
  },
  "home": {
    "title": "Home",
    "scan": "Scan QR",
    "scanDesc": "Scan QR/barcode with camera",
    "create": "Create QR",
    "createDesc": "Create new QR code",
    "history": "History",
    "historyDesc": "Scan & creation history",
    "settings": "Settings",
    "settingsDesc": "Theme, language & other settings"
  },
  "settings": {
    "appearance": "Appearance",
    "language": "Language",
    "backgroundAnimation": "Background Animation"
  },
  "create_qr": {
    "title": "Create QR",
    "subtitle": "What type of QR code do you want to create?",
    "search_hint": "Search QR type...",
    "generate_button": "Generate QR Code",
    "preview_title": "QR Preview",
    "customize": "Customize",
    "dot_style": "Dot Style",
    "dot_square": "Square",
    "dot_round": "Round",
    "dot_circle": "Circle",
    "qr_color": "QR Color",
    "bg_color": "Background",
    "frame_style": "Frame Style",
    "frame_none": "None",
    "frame_solid": "Solid",
    "frame_rounded": "Rounded",
    "frame_dashed": "Dashed",
    "frame_shadow": "Shadow",
    "frame_elegant": "Elegant",
    "logo": "Center Logo",
    "add_logo": "Add Logo",
    "remove_logo": "Remove",
    "save": "Save",
    "share": "Share",
    "copied": "Copied",
    "saved_to_gallery": "Saved to gallery",
    "svg_saved": "SVG file saved",
    "save_error": "Could not save",
    "types": {
      "url": "URL",
      "url_desc": "Website link",
      "text": "Text",
      "text_desc": "Free text",
      "wifi": "Wi-Fi",
      "wifi_desc": "Network info",
      "phone": "Phone",
      "phone_desc": "Call number",
      "sms": "SMS",
      "sms_desc": "Send message",
      "email": "E-mail",
      "email_desc": "Mail address",
      "vcard": "Contact",
      "vcard_desc": "Contact info",
      "location": "Location",
      "location_desc": "Map coordinates",
      "social": "Social Media",
      "social_desc": "Profile link",
      "appStore": "App Store",
      "appStore_desc": "App store link",
      "crypto": "Crypto Wallet",
      "crypto_desc": "Wallet address"
    },
    "help": {
      "title": "How It Works?",
      "url": "A URL QR code directs the user to a website when scanned.\n\nEnter the full URL (including https://). The browser opens automatically when scanned.",
      "text": "A Text QR code displays free text when scanned.\n\nYou can add notes, messages or any text content. No internet connection required.",
      "wifi": "A Wi-Fi QR code automatically connects the device to the specified network when scanned.\n\nEnter the network name (SSID), password and encryption type. Let your guests connect easily.",
      "phone": "A Phone QR code prepares a call to the specified number when scanned.\n\nEnter the phone number including country code. The scanner can call with a single tap.",
      "sms": "An SMS QR code creates a ready message to the specified number when scanned.\n\nEnter the phone number and optional message text.",
      "email": "An Email QR code opens a new email draft when scanned.\n\nEnter the recipient address, subject and message content. The scanner can send it directly.",
      "vcard": "A Contact QR code allows adding contact info to the phonebook when scanned.\n\nEnter name, phone, email and company info. Can be used instead of a business card.",
      "location": "A Location QR code opens the specified coordinates in a map app when scanned.\n\nEnter latitude and longitude values. Ideal for sharing business or event locations.",
      "social": "A Social Media QR code redirects to the specified platform when scanned.\n\nSelect a platform and enter your username. Make it easy for followers to find you.",
      "appStore": "An App Store QR code opens your app's store page when scanned.\n\nSelect a platform and enter the store URL. Make it easy for users to download your app.",
      "crypto": "A Crypto Wallet QR code transfers payment information when scanned.\n\nSelect a cryptocurrency, enter your wallet address and optionally an amount."
    },
    "fields": {
      "url": "Website URL",
      "text": "Text",
      "ssid": "Network Name (SSID)",
      "password": "Password",
      "encryption": "Encryption",
      "hidden_network": "Hidden Network",
      "phone_number": "Phone Number",
      "message": "Message",
      "email_address": "E-mail Address",
      "subject": "Subject",
      "full_name": "Full Name",
      "company": "Company",
      "latitude": "Latitude",
      "longitude": "Longitude",
      "platform": "Platform",
      "username": "Username",
      "username_hint": "example_user",
      "store_platform": "Store Platform",
      "store_url": "Store URL",
      "coin": "Cryptocurrency",
      "wallet_address": "Wallet Address",
      "wallet_hint": "Paste wallet address",
      "amount": "Amount (Optional)",
      "save_svg": "Save SVG"
    }
  },
  "history": {
    "title": "History",
    "search": "Search history...",
    "filter_all": "All",
    "filter_created": "Created",
    "filter_scanned": "Scanned",
    "empty_title": "No history yet",
    "empty_subtitle": "Your QR codes will appear here when you create or scan them.",
    "clear_all": "Clear All",
    "clear_all_confirm": "All history will be deleted. This action cannot be undone.",
    "delete": "Delete",
    "no_title": "Untitled"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"tr": _tr, "en": _en};
}
