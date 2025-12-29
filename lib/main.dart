import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/main_tab_screen.dart';
import 'services/spotify_service.dart';
import 'services/parental_controls_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final prefs = await SharedPreferences.getInstance();
  final parentalControls = ParentalControlsService(prefs);
  final spotifyService = SpotifyService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => spotifyService),
        ChangeNotifierProvider(create: (_) => parentalControls),
      ],
      child: const SpotifyForTeensApp(),
    ),
  );
}

class SpotifyForTeensApp extends StatelessWidget {
  const SpotifyForTeensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify for Teens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Consumer<SpotifyService>(
        builder: (context, spotify, _) {
          return spotify.isAuthenticated 
            ? const MainTabScreen()
            : const LoginScreen();
        },
      ),
    );
  }
}
