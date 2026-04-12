# My Flutter App

## Proje Açıklaması

Bu Flutter uygulaması, kullanıcıların ürünleri keşfedebileceği, sepete ekleyebileceği ve ödeme yapabileceği bir e-ticaret uygulamasıdır. API entegrasyonu ile gerçek zamanlı veri çekme, cache sistemi ve kullanıcı dostu arayüz özellikleri içerir.

## Özellikler

- API ile Ürün keşfi ve listeleme
- **Sepet yönetimi** - Sepete eklenen ürünler uygulama kapatılsa dahi korunur (SharedPreferences)
- **Güvenli ödeme sistemi** - Kart bilgileri isteğe bağlı olarak kaydedilebilir (SharedPreferences)
- Cache sistemi ile performans optimizasyonu
- Ürün arama
- Responsive tasarım

## Kullanılan Flutter Sürümü

Flutter SDK: ^3.10.4

## Çalıştırma Adımları

### Gereksinimler

- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator veya fiziksel cihaz

### Kurulum

1. **Projeyi klonlayın:**
   ```bash
   git clone <https://github.com/AhmetBoy/eCommerce-Flutter.git>
   cd eCommerce-Flutter
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Flutter doctor ile ortamı kontrol edin:**
   ```bash
   flutter doctor
   ```

4. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

### Build İşlemleri

**Android APK oluşturmak için:**
```bash
flutter build apk --release
```

**iOS için:**
```bash
flutter build ios --release
```

## Proje Yapısı

```
lib/
├── models/
│   ├── product.dart
│   └── payment_info.dart
├── screens/
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── product_detail_screen.dart
│   └── cart_payment_screen.dart
├── services/
│   ├── api_service.dart
│   ├── cart_service.dart
│   └── payment_service.dart
└── widgets/
    ├── product_card.dart
    └── product_list_card.dart
```

## API Entegrasyonu

Uygulama, ürün verilerini https://wantapi.com API'sinden çeker. Cache sistemi ile performans optimize edilmiştir.

## Lisans

Bu proje özel kullanım içindir.
