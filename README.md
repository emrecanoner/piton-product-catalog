# Product Catalog App

A Flutter application for displaying and managing product catalogs.

## Features

- User authentication (login/register)
- Product listing by categories
- Product details with favorite functionality
- Multi-language support (TR/EN)
- Biometric authentication
- 24-hour cache system
- Responsive design

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
