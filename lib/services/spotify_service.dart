import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/config.dart';
import '../models/track.dart';

class SpotifyService extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  
  final _storage = const FlutterSecureStorage();
  
  bool get isAuthenticated => _accessToken != null && 
      (_tokenExpiry?.isAfter(DateTime.now()) ?? false);

  /// Initialize service and load saved tokens
  Future<void> initialize() async {
    _accessToken = await _storage.read(key: 'spotify_access_token');
    _refreshToken = await _storage.read(key: 'spotify_refresh_token');
    
    final expiryStr = await _storage.read(key: 'spotify_token_expiry');
    if (expiryStr != null) {
      _tokenExpiry = DateTime.parse(expiryStr);
    }
    
    notifyListeners();
  }

  /// Start Spotify OAuth authentication flow
  Future<bool> authenticate() async {
    try {
      final scopes = Config.spotifyScopes.join('%20');
      final authUrl = Uri.parse(
        '${Config.spotifyAuthUrl}'
        '?client_id=${Config.spotifyClientId}'
        '&response_type=code'
        '&redirect_uri=${Uri.encodeComponent(Config.redirectUri)}'
        '&scope=$scopes'
        '&show_dialog=true'
      );

      // Launch browser for OAuth
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    }
  }

  /// Exchange authorization code for access token
  Future<bool> handleAuthCallback(String code) async {
    try {
      final response = await http.post(
        Uri.parse(Config.spotifyTokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ${base64Encode(
            utf8.encode('${Config.spotifyClientId}:${Config.spotifyClientSecret}')
          )}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': Config.redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokens(
          data['access_token'],
          data['refresh_token'],
          data['expires_in'],
        );
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Token exchange error: $e');
      return false;
    }
  }

  /// Save tokens securely
  Future<void> _saveTokens(String accessToken, String? refreshToken, int expiresIn) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: 'spotify_access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'spotify_refresh_token', value: refreshToken);
    }
    await _storage.write(key: 'spotify_token_expiry', value: _tokenExpiry!.toIso8601String());
  }

  /// Refresh access token
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse(Config.spotifyTokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ${base64Encode(
            utf8.encode('${Config.spotifyClientId}:${Config.spotifyClientSecret}')
          )}',
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken!,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokens(
          data['access_token'],
          data['refresh_token'] ?? _refreshToken,
          data['expires_in'],
        );
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  /// Make authenticated API request
  Future<http.Response?> _makeRequest(String endpoint) async {
    if (!isAuthenticated) {
      // Try to refresh token
      if (!await _refreshAccessToken()) {
        return null;
      }
    }

    try {
      final response = await http.get(
        Uri.parse('${Config.spotifyApiBaseUrl}$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 401) {
        // Token expired, try refresh
        if (await _refreshAccessToken()) {
          return await _makeRequest(endpoint);
        }
      }

      return response;
    } catch (e) {
      debugPrint('API request error: $e');
      return null;
    }
  }

  /// Search for tracks
  Future<List<Track>> searchTracks(String query) async {
    final response = await _makeRequest(
      '/search?q=${Uri.encodeComponent(query)}&type=track&limit=20'
    );

    if (response != null && response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = (data['tracks']['items'] as List)
          .map((item) => Track.fromJson(item))
          .toList();
      return tracks;
    }

    return [];
  }

  /// Get featured playlists
  Future<List<Playlist>> getFeaturedPlaylists() async {
    final response = await _makeRequest('/browse/featured-playlists?limit=20');

    if (response != null && response.statusCode == 200) {
      final data = json.decode(response.body);
      final playlists = (data['playlists']['items'] as List)
          .map((item) => Playlist.fromJson(item))
          .toList();
      return playlists;
    }

    return [];
  }

  /// Get playlist tracks
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    final response = await _makeRequest('/playlists/$playlistId/tracks');

    if (response != null && response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = (data['items'] as List)
          .where((item) => item['track'] != null)
          .map((item) => Track.fromJson(item['track']))
          .toList();
      return tracks;
    }

    return [];
  }

  /// Logout
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    
    await _storage.deleteAll();
    notifyListeners();
  }
}
