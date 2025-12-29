# Spotify for Teens - Flutter App

A safe and controlled music streaming experience for teenagers, built with Flutter and Spotify Premium APIs with enhanced parental controls and content filtering.

## 🎯 Features

- **Cross-Platform**: Single codebase for iOS and Android
- **Music-Only Experience**: Browse and listen to music without videos, clips, or other distracting content
- **Advanced Content Filtering**: Multi-level content filtering system with customizable parental controls
- **Explicit Content Blocking**: Automatically filter out explicit content
- **Keyword Filtering**: Block songs containing specific keywords in titles or artist names
- **PIN Protection**: Secure parental controls with PIN authentication
- **Clean UI**: Modern Material Design interface
- **Background Audio**: Continue listening while using other apps
- **Develop on Linux**: Build iOS apps without owning a Mac using GitHub Actions!

## 📋 Requirements

- Flutter 3.16.0+
- Dart 3.0.0+
- Spotify Premium account
- Spotify Developer credentials
- For iOS builds: GitHub account (free macOS runners) OR macOS device

## 🚀 Getting Started

### 1. Install Flutter

#### On Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### On macOS:
```bash
brew install flutter
flutter doctor
```

#### On Windows:
Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)

### 2. Clone the Repository

```bash
cd "Spotify for Teens"
```

### 3. Set Up Spotify Developer Account

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create a new app
3. Note your **Client ID** and **Client Secret**
4. Add redirect URI: `spotifyforteens://callback`

### 4. Configure API Credentials

Open [lib/config/config.dart](lib/config/config.dart) and replace the placeholders:

```dart
static const String spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID_HERE';
static const String spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET_HERE';
```

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Run on Android (Linux, macOS, Windows)

```bash
flutter run
```

### 7. Build iOS Without a Mac

Push your code to GitHub and let GitHub Actions build iOS automatically:

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

The GitHub Actions workflow will automatically build iOS on every push!

## 📱 App Structure

```
lib/
├── main.dart                          # App entry point
├── config/
│   └── config.dart                   # API credentials and configuration
├── models/
│   ├── track.dart                    # Track, Artist, Album, Playlist models
│   └── content_filter.dart           # Content filtering logic
├── services/
│   ├── spotify_service.dart          # Spotify API integration
│   └── parental_controls_service.dart # Parental controls management
└── screens/
    ├── login_screen.dart             # Spotify authentication
    ├── main_tab_screen.dart          # Main navigation
    ├── browse_screen.dart            # Browse playlists
    ├── search_screen.dart            # Search for music
    ├── player_screen.dart            # Music player
    └── parental_controls_screen.dart # Settings and controls
```

## 🔒 Parental Controls

### Content Rating Levels

- **Everyone (Strict)**: Most restrictive, blocks explicit content and applies keyword filtering
- **Teen 13+ (Default)**: Moderate filtering, blocks explicit content
- **Custom**: User-defined filters with custom keyword lists

### Setting Up Parental Controls

1. Navigate to the "Controls" tab
2. Set a 4-digit PIN to protect settings
3. Choose a content filter level
4. Add custom blocked keywords if needed

### Content Filtering Features

- Block explicit content flag
- Custom keyword blacklist
- Genre restrictions (optional)
- Real-time filtering during search and browse

## 🔧 Configuration Options

### Content Filter Settings

Edit [lib/models/content_filter.dart](lib/models/content_filter.dart) to customize default filters:

```dart
static const strict = ContentFilter(
  maxRating: ContentRating.everyone,
  blockExplicitContent: true,
  blockedKeywords: ['drug', 'violence', 'explicit'],
  allowedGenres: ['pop', 'rock', 'indie', 'electronic', 'classical'],
);
```

## 🤖 GitHub Actions - Build iOS Without a Mac!

This project includes GitHub Actions workflows that automatically build your app on every push.

### What Gets Built Automatically:

- ✅ **Android APK** (for direct installation)
- ✅ **Android App Bundle** (for Google Play Store)
- ✅ **iOS Build** (using macOS runners - **FREE** 2,000 minutes/month!)

### How It Works:

1. **Push code to GitHub**
2. **GitHub Actions automatically triggers**
3. **macOS runner builds iOS app**
4. **Download .app or .ipa from Artifacts tab**

### Workflow Files:

- [`.github/workflows/build.yml`](.github/workflows/build.yml) - Builds on every push
- [`.github/workflows/release.yml`](.github/workflows/release.yml) - Creates releases on tags

### Usage:

```bash
# Regular development - triggers build workflow
git push origin main

# Create a release - triggers release workflow
git tag v1.0.0
git push origin v1.0.0
```

### For Signed iOS Builds (App Store):

Add these secrets to your GitHub repository:

1. Go to: **Settings → Secrets and variables → Actions**
2. Add:
   - `IOS_CERTIFICATE_P12`: Your .p12 certificate (base64 encoded)
   - `IOS_CERTIFICATE_PASSWORD`: Certificate password
   - `IOS_PROVISIONING_PROFILE`: Provisioning profile (base64 encoded)

Then uncomment the signing steps in [`.github/workflows/build.yml`](.github/workflows/build.yml).

### Free macOS Build Minutes:

- **Public repos**: Unlimited
- **Private repos**: 2,000 minutes/month (free tier)
- Typical iOS build: ~10-15 minutes

**No Mac needed! 🎉**

## 🛠 Development

### Running on Different Platforms

```bash
# Run on Android
flutter run

# Run on iOS (requires macOS or use GitHub Actions)
flutter run

# Run on web (for testing UI)
flutter run -d chrome

# Build release versions
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS (on macOS)
```

### Hot Reload

Flutter's hot reload lets you see changes instantly:
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Project Setup

The app follows standard Flutter architecture:

- **Models**: Data structures (`Track`, `ContentFilter`, etc.)
- **Services**: Business logic (API calls, state management)
- **Screens**: UI components (widgets)

### State Management

Uses Provider for state management:
- `SpotifyService`: Handles authentication and API calls
- `ParentalControlsService`: Manages content filtering settings

### Adding New Features

Example: Add a new screen

1. Create file: `lib/screens/my_screen.dart`
2. Add navigation in appropriate screen
3. Update state if needed

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 📚 API Documentation

- [Spotify Web API Reference](https://developer.spotify.com/documentation/web-api/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [OAuth Authentication Flow](https://developer.spotify.com/documentation/general/guides/authorization-guide/)

## 💡 Why Flutter?

### Benefits Over Native iOS Development:

1. **Develop on Linux/Windows/macOS** - No Mac required for development!
2. **Single Codebase** - iOS + Android from the same code
3. **Hot Reload** - See changes instantly without recompiling
4. **GitHub Actions** - Build iOS apps using free macOS runners
5. **Cost Effective** - No need to buy a Mac ($1000+)
6. **Faster Development** - Shared code means less duplication

### Development Workflow:

```
Write Code on Linux → Push to GitHub → GitHub Actions Builds iOS → Download .ipa
```

## ⚠️ Important Notes

### Spotify API Status

This project uses the Spotify Web API for all functionality:

1. **Authentication**: OAuth 2.0 flow
2. **Search & Browse**: RESTful API calls
3. **Playback**: Web Playback SDK or native integration

### API Rate Limits

Spotify enforces rate limits on API calls. The app implements:
- Request throttling
- Caching where appropriate
- Error handling for rate limit responses

### Premium Account Required

This app requires a Spotify Premium subscription for playback features.

### Platform Support

- ✅ **Android**: Full support, develop & build on Linux
- ✅ **iOS**: Full support, develop on Linux, build via GitHub Actions
- ⚠️ **Web**: UI works, but Spotify playback limited
- ❌ **Desktop**: Not implemented (could be added)

## 🔐 Security

- **Never commit API credentials** to version control
- Store credentials in Config.swift (already in .gitignore)
- Use Keychain for storing user tokens
- Implement PIN-based parental control access

## 🤝 Contributing

This is a personal project, but suggestions are welcome:

1. Test the app thoroughly
2. Report bugs or suggest features
3. Ensure all content filtering works as expected

## 📄 License

This project is for personal/educational use. Spotify and the Spotify logo are trademarks of Spotify AB.

## 🆘 Troubleshooting

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Flutter installation
flutter doctor
```

### Android Issues

- Ensure Java 17 is installed
- Check Android SDK is properly configured
- Update Android Studio if needed

### iOS Issues (GitHub Actions)

- Verify workflow file syntax
- Check GitHub Actions logs for errors
- Ensure you're using latest Flutter version in workflow

### Authentication Issues

- Verify your Client ID and Secret are correct
- Ensure redirect URI matches in Spotify Dashboard and [lib/config/config.dart](lib/config/config.dart)
- Check that your Spotify account has Premium
- Test OAuth flow in browser first

### Content Not Loading

- Verify Spotify API credentials
- Check network connectivity
- Ensure authentication is successful
- Review API rate limits in logs

### Linux-Specific

```bash
# Install required libraries
sudo apt install clang cmake ninja-build libgtk-3-dev

# Fix common issues
flutter doctor --android-licenses
```

## 📞 Support

- **Spotify API Issues**: [Spotify Developer Forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer)
- **Flutter Issues**: [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- **GitHub Actions**: [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is for personal/educational use. Spotify and the Spotify logo are trademarks of Spotify AB.

## 🎓 Learning Resources

- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Dart Language Tutorial](https://dart.dev/tutorials)
- [Building iOS Apps on Linux Guide](https://flutter.dev)
- [GitHub Actions for Mobile Apps](https://docs.github.com/en/actions/deployment/deploying-to-google-kubernetes-engine)

---

**Built with Flutter 💙 | Develop on Linux 🐧 | Deploy to iOS via GitHub Actions 🚀**

**Note**: This app demonstrates integration with Spotify's APIs while adding family-friendly content controls. Perfect for learning cross-platform development without owning a Mac! Always comply with Spotify's Terms of Service and API usage guidelines.
