# Testing Guide

## Known Issues

### Linux Desktop Build Error
The snap-packaged Flutter has incompatible GLib library versions that prevent building on Linux desktop. The error:
```
undefined reference to `g_task_set_static_name'
undefined reference to `g_once_init_enter_pointer'  
undefined reference to `g_once_init_leave_pointer'
```

This is a known issue with Flutter snap + libsecret + Ubuntu 24.04.

### Alternative Testing Options

#### Option 1: GitHub Actions (Recommended for iOS)
Your iOS builds will work automatically via GitHub Actions when you push code:
- Navigate to: https://github.com/troyhite/spotify-for-teens/actions
- Each push triggers Android APK and iOS IPA builds
- Download artifacts from completed workflow runs

#### Option 2: Android Emulator
1. Install Android Studio
2. Create an Android Virtual Device (AVD)
3. Run: `flutter run -d android`

#### Option 3: Install Flutter via git (not snap)
```bash
# Remove snap Flutter
sudo snap remove flutter

# Install via git
cd ~
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc

# Verify
flutter doctor
```

Then try Linux desktop build again.

## Configuring Spotify API

Before testing authentication, you need to register your app with Spotify:

### 1. Create Spotify App
1. Go to https://developer.spotify.com/dashboard
2. Log in with your Spotify account (requires Spotify Premium)
3. Click "Create app"
4. Fill in:
   - **App name**: Spotify for Teens
   - **App description**: Music streaming app with parental controls
   - **Redirect URI**: `spotifyforteens://callback`
   - **Which API/SDKs are you planning to use**: Web API

### 2. Get Credentials
After creating the app:
1. Click on your app in the dashboard
2. Go to "Settings"
3. Copy the **Client ID**
4. Click "View client secret" and copy the **Client Secret**

### 3. Update App Configuration
Edit `lib/config/config.dart`:

```dart
class Config {
  static const String spotifyClientId = 'YOUR_CLIENT_ID_HERE';
  static const String spotifyClientSecret = 'YOUR_CLIENT_SECRET_HERE';
  static const String spotifyRedirectUri = 'spotifyforteens://callback';
  static const List<String> spotifyScopes = [
    'user-read-private',
    'user-read-email',
    'user-library-read',
    'streaming',
    'playlist-read-private',
    'playlist-read-collaborative',
  ];
}
```

### 4. Test Features
Once running on a working platform:
1. **Login**: Tap "Login with Spotify" - should redirect to browser for OAuth
2. **Browse**: View featured playlists with album art
3. **Search**: Search tracks - explicit content should show warning icon
4. **Parental Controls**: 
   - Set PIN (4 digits)
   - Change filter level (Teen 13+ vs Strict)
   - Verify explicit tracks are filtered
5. **Playback**: Tap track to open player screen (requires Spotify Premium account)

## Testing Content Filtering

The app implements two filter levels:

### Teen (13+) - Default
- Blocks tracks marked as explicit by Spotify
- No keyword filtering

### Strict (Everyone)
- Blocks explicit tracks
- Blocks tracks with keywords: `['explicit', 'drugs', 'violence', 'profanity']`
- Can be customized in `lib/models/content_filter.dart`

## Debugging Tips

### Check Flutter Installation
```bash
flutter doctor -v
```

### View Available Devices
```bash
flutter devices
```

### Clean Build Cache
```bash
flutter clean
flutter pub get
```

### Check Dependencies
```bash
flutter pub outdated
flutter pub deps
```

### Verbose Build Output
```bash
flutter run -d <device> -v
```
