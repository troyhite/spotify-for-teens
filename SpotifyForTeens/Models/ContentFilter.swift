//
//  ContentFilter.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import Foundation

enum ContentRating: Int {
    case everyone = 0       // All ages
    case teen = 1          // 13+
    case mature = 2        // 17+
    case explicit = 3      // Explicit content
}

struct ContentFilter {
    var maxRating: ContentRating
    var blockExplicitContent: Bool
    var blockedKeywords: [String]
    var allowedGenres: [String]?
    
    static let `default` = ContentFilter(
        maxRating: .teen,
        blockExplicitContent: true,
        blockedKeywords: [],
        allowedGenres: nil
    )
    
    static let strict = ContentFilter(
        maxRating: .everyone,
        blockExplicitContent: true,
        blockedKeywords: ["drug", "violence", "explicit"],
        allowedGenres: ["pop", "rock", "indie", "electronic", "classical"]
    )
    
    func isContentAllowed(_ track: Track) -> Bool {
        // Block explicit content if setting is enabled
        if blockExplicitContent && track.isExplicit {
            return false
        }
        
        // Check for blocked keywords in track name
        let trackNameLower = track.name.lowercased()
        for keyword in blockedKeywords {
            if trackNameLower.contains(keyword.lowercased()) {
                return false
            }
        }
        
        // Check for blocked keywords in artist names
        let artistNameLower = track.artistNames.lowercased()
        for keyword in blockedKeywords {
            if artistNameLower.contains(keyword.lowercased()) {
                return false
            }
        }
        
        return true
    }
}

class ParentalControlsManager {
    static let shared = ParentalControlsManager()
    
    private let filterKey = "com.spotifyforteens.contentfilter"
    private let pinKey = "com.spotifyforteens.parentalpin"
    
    var currentFilter: ContentFilter {
        get {
            if let data = UserDefaults.standard.data(forKey: filterKey),
               let filter = try? JSONDecoder().decode(ContentFilter.self, forKey: data) {
                return filter
            }
            return .default
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: filterKey)
            }
        }
    }
    
    var isPinSet: Bool {
        return UserDefaults.standard.string(forKey: pinKey) != nil
    }
    
    func setPin(_ pin: String) {
        UserDefaults.standard.set(pin, forKey: pinKey)
    }
    
    func verifyPin(_ pin: String) -> Bool {
        return UserDefaults.standard.string(forKey: pinKey) == pin
    }
    
    func clearPin() {
        UserDefaults.standard.removeObject(forKey: pinKey)
    }
}

extension ContentFilter: Codable {
    enum CodingKeys: String, CodingKey {
        case maxRating, blockExplicitContent, blockedKeywords, allowedGenres
    }
}
