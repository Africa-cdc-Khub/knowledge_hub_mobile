# Africa CDC Knowledge Management Mobile App

The **Africa CDC Knowledge Management Mobile App** is a Flutter-based application developed to facilitate knowledge sharing, collaboration, and public health management across Africa. This app empowers health professionals, researchers, and policymakers by providing accessible resources and interactive features for real-time knowledge exchange.

## Key Features
- **Knowledge Publishing**: Access and publish essential public health documents, research, and guidelines to stay informed on the latest health developments.
- **Discussion Forums**: Connect with public health experts to exchange ideas and collaborate on critical issues such as outbreak response and policy formulation.
- **AI Document Comparison**: Leverage AI-powered tools to compare documents, track changes, and ensure accuracy in public health documentation.
- **Social Document Sharing**: Easily share documents with colleagues and stakeholders on social platforms, promoting widespread knowledge dissemination.

## Technology Stack
- **Frontend**: Flutter (cross-platform support for iOS and Android)
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
- **Backend**: Laravel (PHP framework)
- **Database**: MySQL
- **Search**: Elasticsearch for fast, accurate information retrieval

## Installation
For developers who want to set up the project locally for development or customization, please follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/africacdc/knowledge-management-mobile-app.git


## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Features

- [List key features of the app]
- [Feature 1]
- [Feature 2]
- [Feature 3]

## Requirements

- Flutter SDK 3.22.2 or higher
- Android SDK
- Xcode (for iOS development)
- [Any other specific requirements]

## Setup

1. Clone the repository:
   ```
   git clone <repository>/khub-mobile.git
   cd khub-mobile
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Create a file called `local.properties` in the `android` folder and add the following:
   ```
   sdk.dir=/path/to/your/Android/sdk
   flutter.sdk=/path/to/your/flutter/sdk
   flutter.buildMode=release
   flutter.versionName=1.0.2
   flutter.versionCode=3
   ```
4. Create a file called `keystore.properties` in the `android` folder and add the following:
   ```
   storeFile=../app/<keystore-file>.jks
   storePassword=<password>
   keyPassword=<password>
   keyAlias=<alias>
   ```
   Note: Adjust the paths and values according to your local setup.

4. Generate the arb (language) files:
   ```
    flutter gen-l10n 
   ```

## Running the App

To run the app in debug mode:

```
flutter run
```

For different flavors or environments:

```
flutter run --flavor dev
flutter run --flavor prod
```

## Testing

To run the tests:

```
flutter test
```

## Deployment

[Provide instructions for building and deploying the app]

### Android

[Steps for building and deploying to Android]

### iOS

[Steps for building and deploying to iOS]

## Contributing

We welcome contributions to KHub Mobile! Please follow these steps:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit them: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Submit a pull request

Please make sure to update tests as appropriate and adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

[Specify the license under which this project is released]

## Resources

For more information on Flutter development:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Community](https://flutter.dev/community)
