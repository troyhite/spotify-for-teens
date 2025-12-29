//
//  Config.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import Foundation

struct Config {
    // IMPORTANT: Replace these with your actual Spotify API credentials
    // Get them from: https://developer.spotify.com/dashboard
    static let spotifyClientID = "YOUR_SPOTIFY_CLIENT_ID_HERE"
    static let spotifyClientSecret = "YOUR_SPOTIFY_CLIENT_SECRET_HERE"
    static let redirectURI = "spotifyforteens://callback"
    
    // API Endpoints
    static let spotifyAuthURL = "https://accounts.spotify.com/authorize"
    static let spotifyTokenURL = "https://accounts.spotify.com/api/token"
    static let spotifyAPIBaseURL = "https://api.spotify.com/v1"
    
    // Scopes required for the app
    static let spotifyScopes = [
        "user-read-playback-state",
        "user-modify-playback-state",
        "user-read-currently-playing",
        "streaming",
        "user-library-read",
        "user-library-modify",
        "playlist-read-private",
        "playlist-read-collaborative"
    ]
}
