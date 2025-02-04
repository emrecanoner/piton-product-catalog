# Product Catalog App

Modern bir kitap kataloğu uygulaması, Flutter ile geliştirilmiştir.

![Splash Screen](assets/app/splash.png)

## Özellikler

- 🔐 Kullanıcı Kimlik Doğrulama
  - Giriş/Kayıt sistemi
  - Beni Hatırla özelliği
  - Form validasyonları
  
- 📚 Ürün Yönetimi
  - Kategorilere göre kitap listeleme
  - Detaylı kitap sayfaları
  - Favori kitap işaretleme
  - Arama fonksiyonu
  
- 🌍 Çoklu Dil Desteği
  - Türkçe
  - İngilizce
  
- 💫 Kullanıcı Deneyimi
  - Responsive tasarım
  - Kolay gezinme
  - Kategori filtreleme
  - Arama özelliği

## Ekran Görüntüleri

| Giriş | Ana Sayfa | Ürün Detay |
|:---:|:---:|:---:|
| ![Login](assets/app/login.png) | ![Home](assets/app/home.png) | ![Product Detail](assets/app/product_detail.png) |

| Kayıt | Kategori Detay |
|:---:|:---:|
| ![Register](assets/app/register.png) | ![Category Detail](assets/app/category_detail.png) |

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / Xcode (for running on emulators)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/product-catalog.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## Architecture

- State Management: Riverpod
- Dependency Injection: Injectable
- Network Layer: Dio
- Local Storage: Hive & SharedPreferences
- Code Generation: Freezed

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── init/
│   └── utils/
├── features/
│   ├── auth/
│   ├── home/
│   ├── product/
│   └── splash/
└── product/
    ├── cache/
    ├── di/
    ├── models/
    └── widgets/
```

## Testing

To run the tests:
```bash
flutter test
```

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
